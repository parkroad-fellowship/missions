import 'package:app/models/remote/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:logger/logger.dart';

abstract class SocketService {
  SocketConfig config();
  Future<void> init();
}

class SocketServiceImpl implements SocketService {
  PusherChannelsClient _initClient() {
    final hostOptions = PusherChannelsOptions.fromHost(
      scheme: PRFSuperAppConfig.instance!.values.socketScheme,
      host: PRFSuperAppConfig.instance!.values.baseDomain,
      key: PRFSuperAppConfig.instance!.values.socketKey,
      port: PRFSuperAppConfig.instance!.values.socketPort,
    );

    Logger().i(hostOptions.uri);

    return PusherChannelsClient.websocket(
      options: hostOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        refresh();
      },
      activityDurationOverride: const Duration(
        seconds: 120,
      ),
    );
  }

  Future<void> _connectClient({required PusherChannelsClient client}) async {
    await client.connect();
  }

  PrivateChannel _registerToPrivateChannel({
    required PusherChannelsClient client,
    required String channelName,
  }) {
    return client.privateChannel(
      'private-$channelName',
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: Uri.parse(
          '${PRFSuperAppConfig.instance!.values.baseUrl}/broadcasting/auth',
        ),
        onAuthFailed: (exception, trace) {
          Logger().e(exception);
          Logger().e(trace);
        },
        headers: const {
          'Authorization':
              'Bearer 2|A3xCSnIbJtM3DW6Kf4Jch6EyW37XVnPj55I9M8GDe5c48ec4',
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
        Logger().i('Subscribed to channel: ${channel.name}');
      }
    });
  }

  void _bindEventToChannel({
    required Channel channel,
    required String eventName,
  }) {
    // Handle data from the socket server here
    channel.bind(eventName).listen((event) {
      Logger().i('Event from the private channel fired!');
      Logger().e(event.data);
    });
  }

  @override
  Future<void> init() async {
    final socketConfig = config();
    final client = _initClient();

    final configuredChannels = <PrivateChannel>[];

    socketConfig.channels.forEach((channelName, events) {
      final channel = _registerToPrivateChannel(
        client: client,
        channelName: channelName,
      );

      for (final eventName in events) {
        _bindEventToChannel(
          channel: channel,
          eventName: eventName,
        );
      }

      configuredChannels.add(channel);
    });

    _subscribeToPrivateChannelsEvent(
      client: client,
      channels: configuredChannels,
    );

    await _connectClient(client: client);
  }

  @override
  SocketConfig config() {
    final user = HiveServiceImpl().retrieveProfile()!;
    // Register all channels and their events here
    // Assumption here is that there's only one channel for that user
    // Should more be needed, this function may need adjusting
    return SocketConfig(
      channels: <String, List<String>>{
        'App.Models.User.${user.ulid}': <String>[
          r'App\Events\CoolBeans',
        ],
      },
    );
  }
}
