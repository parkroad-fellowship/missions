import 'package:app/utils/_index.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:logger/logger.dart';

abstract class SocketService {
  PusherChannelsClient initClient();
  Future<void> connectClient({required PusherChannelsClient client});
  PrivateChannel registerToPrivateChannel({
    required PusherChannelsClient client,
    required String channelName,
  });
  void bindEventToChannel({
    required Channel channel,
    required String eventName,
  });
  void subscribeToPrivateChannelsEvent({
    required PusherChannelsClient client,
    required List<Channel> channels,
  });
}

class SocketServiceImpl implements SocketService {
  @override
  PusherChannelsClient initClient() {
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

  @override
  Future<void> connectClient({required PusherChannelsClient client}) async {
    await client.connect();
  }

  @override
  PrivateChannel registerToPrivateChannel({
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

  @override
  void subscribeToPrivateChannelsEvent({
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

  @override
  void bindEventToChannel({
    required Channel channel,
    required String eventName,
  }) {
    // Sample listener
    channel.bind(eventName).listen((event) {
      Logger().i('Event from the private channel fired!');
      Logger().e(event.data);
    });
  }
}
