import 'dart:async';
import 'dart:convert';

import 'package:app/di/_index.dart';
import 'package:app/enums/event/prf_event.dart';
import 'package:app/models/remote/common/socket_config.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:logger/logger.dart';

abstract class SocketService {
  SocketConfig defaultConfig();
  Future<void> init({required SocketConfig socketConfig});
  Future<void> dispose();
  Stream<bool> get connectionState;
}

class SocketServiceImpl implements SocketService {
  SocketServiceImpl({required IsarService isarService}) {
    _isarService = isarService;
  }

  late IsarService _isarService;
  PusherChannelsClient? _client;
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  @override
  Stream<bool> get connectionState => _connectionStateController.stream;

  PusherChannelsClient _initClient() {
    final hostOptions = PusherChannelsOptions.fromHost(
      scheme: PRFSuperAppConfig.instance!.values.socketScheme,
      host: PRFSuperAppConfig.instance!.values.socketDomain,
      key: PRFSuperAppConfig.instance!.values.socketKey,
      port: PRFSuperAppConfig.instance!.values.socketPort,
    );

    return PusherChannelsClient.websocket(
      options: hostOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        Logger().f(exception);
        Logger().f(trace);
        _connectionStateController.add(false);
        refresh();
      },
      activityDurationOverride: const Duration(seconds: 120),
    );
  }

  Future<void> _connectClient({required PusherChannelsClient client}) async {
    await client
        .connect()
        .then((onValue) {
          Logger().i('Successfully connected to the socket server');
          _connectionStateController.add(true);
        })
        .onError((error, stackTrace) {
          Logger().e(
            'An error occurred connecting to the socket server',
            error: error,
            stackTrace: stackTrace,
          );
          _connectionStateController.add(false);
        });
  }

  PrivateChannel _registerToPrivateChannel({
    required PusherChannelsClient client,
    required String channelName,
  }) {
    final token = getIt<HiveService>().auth.retrieveToken();

    if (token == null) {
      throw Exception('Authentication token is required for private channels');
    }

    return client.privateChannel(
      'private-$channelName',
      authorizationDelegate:
          // ignore: lines_longer_than_80_chars
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
            authorizationEndpoint: Uri.parse(
              '${PRFSuperAppConfig.instance!.values.baseUrl}/broadcasting/auth',
            ),
            onAuthFailed: (exception, trace) {
              Logger().e(exception);
              Logger().f(trace);
            },
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
    );
  }

  PresenceChannel _registerToPresenceChannel({
    required PusherChannelsClient client,
    required String channelName,
  }) {
    final token = getIt<HiveService>().auth.retrieveToken();

    if (token == null) {
      throw Exception('Authentication token is required for presence channels');
    }

    return client.presenceChannel(
      'presence-$channelName',
      authorizationDelegate:
          // ignore: lines_longer_than_80_chars
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPresenceChannel(
            authorizationEndpoint: Uri.parse(
              '${PRFSuperAppConfig.instance!.values.baseUrl}/broadcasting/auth',
            ),
            onAuthFailed: (exception, trace) {
              Logger().e(exception);
              Logger().e(trace);
            },
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
    );
  }

  void _subscribeToPrivateChannelsEvent({
    required PusherChannelsClient client,
    required List<Channel> channels,
  }) {
    client.onConnectionEstablished.listen((_) {
      for (final channel in channels) {
        channel.subscribeIfNotUnsubscribed();
        Logger().i('Subscribed to private channel: ${channel.name}');
      }
    });
  }

  void _subscribeToPresenceChannelsEvent({
    required PusherChannelsClient client,
    required List<Channel> channels,
  }) {
    client.onConnectionEstablished.listen((_) {
      for (final channel in channels) {
        channel.subscribeIfNotUnsubscribed();
        Logger().i('Subscribed to presence channel: ${channel.name}');
      }
    });
  }

  void _bindEventToPresenceChannel({
    required PresenceChannel channel,
    required String eventName,
  }) {
    // Handle data from the socket server here
    channel
      ..whenMemberAdded().listen((event) {
        Logger().i('Member added to the presence channel ${channel.name}!');
        Logger().e(event.data);
      })
      ..whenMemberRemoved().listen((event) {
        Logger().i('Member removed from the presence channel ${channel.name}!');
        Logger().e(event.data);
      })
      ..bind(eventName).listen((event) {
        Logger().i(
          '$eventName from the presence channel ${channel.name} fired!',
        );
        Logger().e(event.data);

        try {
          final data =
              json.decode(event.data as String) as Map<String, dynamic>;

          switch (PRFPresenceEvent.fromIndex(data['event'] as int)) {
            case PRFPresenceEvent.announcementGroupCreated:
              Logger().f(data['data']);
          }
        } catch (e, stackTrace) {
          Logger().e(
            'Error processing presence channel event',
            error: e,
            stackTrace: stackTrace,
          );
        }
      });
  }

  void _bindEventToChannel({
    required Channel channel,
    required String eventName,
  }) {
    // Handle data from the socket server here
    channel.bind(eventName).listen((event) {
      Logger().i('$eventName from the private channel ${channel.name} fired!');
      Logger().e(event.data);

      try {
        final data = json.decode(event.data as String) as Map<String, dynamic>;

        switch (PRFEvent.fromIndex(data['event'] as int)) {
          case PRFEvent.courseMemberUpdated:
            Logger().f(data['data']);
            final courseData = PRFCourse.fromJson(
              data['data'] as Map<String, dynamic>,
            );

            _isarService.courses.persistEntities(<PRFCourse>[courseData]).then((
              _,
            ) {
              _isarService.courseModules.refreshStream();
            });

          case PRFEvent.memberModuleUpdated:
            Logger().f(data['data']);
            final courseModuleData = PRFCourseModule.fromJson(
              data['data'] as Map<String, dynamic>,
            );

            _isarService.courseModules.persistEntity(courseModuleData).then((
              _,
            ) {
              if (courseModuleData.course != null) {
                _isarService.courseModules.refreshParentStream(
                  courseModuleData.course!.ulid,
                );
              }
            });

          case PRFEvent.lessonMemberUpdated:
            Logger().f(data['data']);
            final lessonModuleData = PRFLessonModule.fromJson(
              data['data'] as Map<String, dynamic>,
            );

            _isarService.lessonModules.persistEntity(lessonModuleData).then((
              _,
            ) {
              if (lessonModuleData.module != null) {
                _isarService.lessonModules.refreshParentStream(
                  lessonModuleData.module!.ulid,
                );
              }
            });

          case PRFEvent.studentEnquiryReplyCreated:
            Logger().f(data['data']);
            final studentEnquiryReplyData = PRFStudentEnquiryReply.fromJson(
              data['data'] as Map<String, dynamic>,
            );

            _isarService.studentEnquiryReplies
                .persistEntity(
                  studentEnquiryReplyData,
                )
                .then((_) {
                  if (studentEnquiryReplyData.studentEnquiry != null) {
                    _isarService.studentEnquiryReplies.refreshParentStream(
                      studentEnquiryReplyData.studentEnquiry!.ulid,
                    );
                  }
                });
        }
      } catch (e, stackTrace) {
        Logger().e(
          'Error processing socket event',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  @override
  Future<void> init({required SocketConfig socketConfig}) async {
    final client = _initClient();
    _client = client;

    final configuredChannels = <PrivateChannel>[];
    final configuredPresenceChannels = <PresenceChannel>[];

    socketConfig.privateChannels.forEach((channelName, events) {
      final privateChannel = _registerToPrivateChannel(
        client: client,
        channelName: channelName,
      );

      for (final eventName in events) {
        _bindEventToChannel(channel: privateChannel, eventName: eventName);
      }

      configuredChannels.add(privateChannel);
    });

    _subscribeToPrivateChannelsEvent(
      client: client,
      channels: configuredChannels,
    );

    socketConfig.presenceChannels?.forEach((channelName, events) {
      final presenceChannel = _registerToPresenceChannel(
        client: client,
        channelName: channelName,
      );

      for (final eventName in events) {
        _bindEventToPresenceChannel(
          channel: presenceChannel,
          eventName: eventName,
        );
      }

      configuredPresenceChannels.add(presenceChannel);
    });
    _subscribeToPresenceChannelsEvent(
      client: client,
      channels: configuredPresenceChannels,
    );

    await _connectClient(client: client);
  }

  @override
  Future<void> dispose() async {
    await _client?.disconnect();
    _client = null;
    await _connectionStateController.close();
  }

  @override
  SocketConfig defaultConfig() {
    final user = getIt<HiveService>().auth.retrieveProfile()!;
    // Register all channels and their events here
    // Assumption here is that there's only one channel for that user
    // Should more be needed, this function may need adjusting

    final privateChannels = <String, List<String>>{
      'App.Models.User.${user.ulid}': <String>[
        r'App\Events\CourseMember\Updated',
        r'App\Events\MemberModule\Updated',
        r'App\Events\LessonMember\Created',
      ],
    };

    final groups = user.member?.groupMembers
        ?.map((groupMember) => groupMember.group?.ulid)
        .toList();

    final presenceChannels = <String, List<String>>{};

    groups?.forEach((groupUlid) {
      presenceChannels.addAll({
        'App.Models.Group.$groupUlid': <String>[
          r'App\Events\AnnouncementGroup\Created',
        ],
      });
    });

    return SocketConfig(
      privateChannels: privateChannels,
      presenceChannels: presenceChannels,
    );
  }
}
