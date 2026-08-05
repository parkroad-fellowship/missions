import 'package:app/enums/common/prf_environment.dart';

class PRFSuperAppValues {
  PRFSuperAppValues({
    required this.environment,
    required this.tenantUlid,
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
    // required this.socketDomain,
    // required this.socketKey,
    // required this.socketScheme,
    // required this.socketPort,
    required this.azureConnString,
    required this.appId,
    required this.appSecret,
    this.hiveEncryptionKey = '',
    this.postHogKey = '',
  });

  final PRFEnvironment environment;
  final String tenantUlid;
  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
  // final String socketDomain;
  // final String socketKey;
  // final String socketScheme;
  // final int socketPort;
  final String azureConnString;
  final String appId;
  final String appSecret;
  final String hiveEncryptionKey;
  final String postHogKey;

  String get baseUrl => '$urlScheme://$baseDomain';
  String get globalHiveAuthBox => 'prf-super-app-auth-';
}

class PRFSuperAppConfig {
  factory PRFSuperAppConfig({required PRFSuperAppValues values}) {
    return _instance ??= PRFSuperAppConfig._internal(values);
  }

  PRFSuperAppConfig._internal(this.values);

  final PRFSuperAppValues values;
  static PRFSuperAppConfig? _instance;

  static PRFSuperAppConfig? get instance => _instance;
}
