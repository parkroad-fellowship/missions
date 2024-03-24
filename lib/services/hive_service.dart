import 'package:app/utils/_index.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveService {
  Future<void> initBoxes();

  void persistToken(String token);
  String? retrieveToken();

  void clearBox();
}

class HiveServiceImplementation implements HiveService {
  @override
  Future<void> initBoxes() async {
    await Hive.initFlutter();

    await Hive.openBox<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
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
}
