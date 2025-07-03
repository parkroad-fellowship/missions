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
}
