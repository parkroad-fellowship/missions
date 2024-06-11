import 'package:app/models/adapters.dart';
import 'package:app/models/auth.dart';
import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_member.dart';
import 'package:app/models/prf_soul.dart';
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
  PRFMember? retrieveMember();

  void persistClassGroups(PRFClassGroupResponse classGroups);
  List<PRFClassGroup> retrieveClassGroups();

  void persistSouls(PRFSoulResponse souls, String missionUlid);
  void persistSoul(PRFSoul soul, String missionUlid);
  List<PRFSoul> retrieveSouls(String missionUlid);
  void clearSouls(String missionUlid);
}

class HiveServiceImpl implements HiveService {
  @override
  Future<void> initBoxes() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(PRFUserAdapter())
      ..registerAdapter(PRFClassGroupResponseAdapter())
      ..registerAdapter(PRFSoulsAdapter());

    await Hive.openBox<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
  }

  @override
  void clearPrefs() {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .deleteAll(<String>[
      'accessToken',
      'profile',
      'classGroups',
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

  @override
  PRFMember? retrieveMember() {
    return retrieveProfile()!.member;
  }

  @override
  void persistClassGroups(PRFClassGroupResponse classGroups) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('classGroups', classGroups);
  }

  @override
  List<PRFClassGroup> retrieveClassGroups() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final classGroups = box.get('classGroups') as PRFClassGroupResponse?;
    if (classGroups == null) return [];
    return classGroups.data;
  }

  @override
  void persistSouls(PRFSoulResponse souls, String missionUlid) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('souls-$missionUlid', souls);
  }

  @override
  void persistSoul(PRFSoul soul, String missionUlid) {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final souls = box.get('souls-$missionUlid') as PRFSoulResponse?;
    if (souls == null) return;
    final modified = List<PRFSoul>.from(souls.data)..add(soul);

    box.put('souls-$missionUlid', PRFSoulResponse(data: modified));
  }

  @override
  List<PRFSoul> retrieveSouls(String missionUlid) {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final souls = box.get('souls-$missionUlid') as PRFSoulResponse?;
    if (souls == null) return [];
    return souls.data.reversed.toList();
  }

  @override
  void clearSouls(String missionUlid) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .delete('souls-$missionUlid');
  }
}
