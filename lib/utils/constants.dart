class PRFSuperAppValues {
  PRFSuperAppValues({
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
    required this.socketDomain,
    required this.socketKey,
    required this.socketScheme,
    required this.socketPort,
    required this.azureConnString,
  });

  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
  final String socketDomain;
  final String socketKey;
  final String socketScheme;
  final int socketPort;
  final String azureConnString;

  String get baseUrl => '$urlScheme://$baseDomain';
  String get globalHiveAuthBox => 'prf-super-app-auth';
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
