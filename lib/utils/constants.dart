class PRFSuperAppValues {
  PRFSuperAppValues({
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
  });

  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
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
