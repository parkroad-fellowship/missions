import 'package:app/hive/hive_registrar.g.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/services/local_storage/hive/auth_hive_service.dart';
import 'package:app/services/local_storage/hive/data_hive_service.dart';
import 'package:app/services/local_storage/hive/settings_hive_service.dart';
import 'package:app/utils/_index.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveService {
  factory HiveService() => instance ??= HiveService._();
  HiveService._();

  static HiveService? instance;
  static const String _binaryAdapterMigrationMarker =
      'hive_binary_adapter_migration_v1';
  static const String _migrationMetaBoxName = 'hive_migration_meta';

  late final AuthHiveService _auth;
  late final DataHiveService _data;
  late final SettingsHiveService _settings;

  AuthHiveService get auth => _auth;
  DataHiveService get data => _data;
  SettingsHiveService get settings => _settings;

  Future<void> initBoxes() async {
    await Hive.initFlutter();

    // Register generated adapters.
    Hive.registerAdapters();

    final appBoxName = PRFSuperAppConfig.instance!.values.hiveBox;
    final globalAuthBoxName =
        PRFSuperAppConfig.instance!.values.globalHiveAuthBox;

    await _runLegacyAdapterMigrationIfNeeded(
      appBoxName: appBoxName,
      globalAuthBoxName: globalAuthBoxName,
    );

    // Open boxes
    await Hive.openBox<dynamic>(appBoxName);
    await Hive.openBox<dynamic>(globalAuthBoxName);

    // Initialize services & sub-services
    _auth = AuthHiveService();
    _settings = SettingsHiveService();

    _data = DataHiveService();
    _data.initialize();
  }

  Future<void> _runLegacyAdapterMigrationIfNeeded({
    required String appBoxName,
    required String globalAuthBoxName,
  }) async {
    final migrationBox = await Hive.openBox<dynamic>(_migrationMetaBoxName);
    final hasMigrated =
        migrationBox.get(_binaryAdapterMigrationMarker) as bool? ?? false;
    if (hasMigrated) {
      await migrationBox.close();
      return;
    }

    // Legacy adapters used JSON-string payloads. Generated adapters use
    // binary fields, so reset once before opening app/global boxes.
    if (await Hive.boxExists(appBoxName)) {
      await Hive.deleteBoxFromDisk(appBoxName);
    }

    if (await Hive.boxExists(globalAuthBoxName)) {
      await Hive.deleteBoxFromDisk(globalAuthBoxName);
    }

    await migrationBox.put(_binaryAdapterMigrationMarker, true);
    await migrationBox.close();
  }

  // Convenience methods that delegate to appropriate services
  void clearPrefs() {
    _auth.clearAuthData();
    _data.clearDataCache();
  }

  void clearBox() {
    _auth.clear();
    _data.clear();
  }

  // Member-related convenience methods
  PRFMember? retrieveMember() {
    return _auth.retrieveProfile()?.member;
  }

  List<String> retrieveMemberGroupUlids() {
    return retrieveMember()!.groupMembers
            ?.map((groupMember) => groupMember.group!.ulid)
            .toList() ??
        [];
  }
}
