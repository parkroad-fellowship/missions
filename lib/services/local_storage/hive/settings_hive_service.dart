import 'package:app/enums/common/prf_theme_mode.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class SettingsHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.globalHiveAuthBox;

  void toggleNotifications({required bool enable}) {
    put('notificationsEnabled', enable);
  }

  bool areNotificationsEnabled() {
    return get<bool>('notificationsEnabled') ?? true;
  }

  void setPermissionRequested({required bool requested}) {
    put('permissionRequested', requested);
  }

  bool hasPermissionBeenRequested() {
    return get<bool>('permissionRequested') ?? false;
  }

  /// Save theme mode preference.
  /// Values: 'system', 'light', 'dark'
  void setThemeMode(PRFThemeMode themeMode) {
    put('themeMode', themeMode.name);
  }

  /// Get saved theme mode preference.
  /// Returns 'system' by default if not set.
  PRFThemeMode getThemeMode() {
    final themeModeName = get<String>('themeMode') ?? PRFThemeMode.system.name;
    return PRFThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeName,
      orElse: () => PRFThemeMode.system,
    );
  }
}
