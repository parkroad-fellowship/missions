class PRFSuperAppValues {
  PRFSuperAppValues({
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
    required this.socketKey,
    required this.socketScheme,
    required this.socketPort,
  });

  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
  final String socketKey;
  final String socketScheme;
  final int socketPort;

  String get baseUrl => '$urlScheme://$baseDomain';
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
