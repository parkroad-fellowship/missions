import 'package:app/models/adapters.dart';
import 'package:app/models/auth.dart';
import 'package:app/utils/_index.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

abstract class HiveService {
  Future<void> initBoxes();
  void clearPrefs();
  void clearBox();

  void persistToken(String token);
  String? retrieveToken();

  void persistProfile(PRFUser profile);
  PRFUser? retrieveProfile();
}

class HiveServiceImpl implements HiveService {
  @override
  Future<void> initBoxes() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PRFUserAdapter());

    await Hive.openBox<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
  }

  @override
  void clearPrefs() {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .deleteAll(<String>[
      'accessToken',
      'profile',
    ]);
  }

  @override
  void clearBox() {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox).clear();
  }

  @override
  void persistToken(String token) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('accessToken', token);
  }

  @override
  String? retrieveToken() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final accessToken = box.get('accessToken') as String?;
    if (accessToken == null) return null;
    return accessToken;
  }

  @override
  void persistProfile(PRFUser profile) {
    Logger().i('Persisting profile: $profile');
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('profile', profile);
  }

  @override
  PRFUser? retrieveProfile() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    return box.get('profile') as PRFUser?;
  }
}
