import 'package:app/models/remote/common/auth.dart';
import 'package:app/services/local_storage/hive/kv/_base_hive_kv_service.dart';
import 'package:app/utils/constants.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class AuthHiveService extends BaseHiveKVService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  // Token management
  void persistToken(String token) {
    putWithExpiry('accessToken', token, const Duration(days: 3));

    // Update logout status in global box
    Hive.box<dynamic>(
      PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
    ).put('isLoggedOut', false);
  }

  String? retrieveToken() {
    final token = getWithExpiry<String>('accessToken');
    if (token == null) {
      Hive.box<dynamic>(
        PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
      ).put('isLoggedOut', true);
    }
    return token;
  }

  bool isLoggedOut() {
    return Hive.box<dynamic>(
              PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
            ).get('isLoggedOut')
            as bool? ??
        false;
  }

  // Profile management
  void persistProfile(PRFUser profile) {
    Logger().i('Persisting profile: $profile');
    put('profile', profile);
  }

  PRFUser? retrieveProfile() {
    return get<PRFUser>('profile');
  }

  String get timezone => retrieveProfile()!.timezone;

  // Clear auth data
  void clearAuthData() {
    deleteAll([
      'accessToken',
      'accessToken_expiry',
      'profile',
    ]);
  }
}
