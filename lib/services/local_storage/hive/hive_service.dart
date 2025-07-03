import 'package:app/models/local/adapters.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/services/local_storage/hive/auth_hive_service.dart';
import 'package:app/services/local_storage/hive/data_hive_service.dart';
import 'package:app/services/local_storage/hive/settings_hive_service.dart';
import 'package:app/utils/_index.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  factory HiveService() => instance ??= HiveService._();
  HiveService._();

  static HiveService? instance;

  late final AuthHiveService _auth;
  late final DataHiveService _data;
  late final SettingsHiveService _settings;

  AuthHiveService get auth => _auth;
  DataHiveService get data => _data;
  SettingsHiveService get settings => _settings;

  Future<void> initBoxes() async {
    await Hive.initFlutter();

    // Register adapters
    Hive
      ..registerAdapter(PRFUserAdapter())
      ..registerAdapter(PRFClassGroupResponseAdapter())
      ..registerAdapter(PRFSoulsAdapter())
      ..registerAdapter(PRFExpenseCategoryResponseAdapter())
      ..registerAdapter(PRFMissionExpenseResponseAdapter())
      ..registerAdapter(PRFPaymentTypeResponseAdapter());

    // Open boxes
    await Hive.openBox<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    await Hive.openBox<dynamic>(
      PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
    );

    // Initialize services
    _auth = AuthHiveService();
    _data = DataHiveService();
    _settings = SettingsHiveService();
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
