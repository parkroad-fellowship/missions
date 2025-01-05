import 'package:app/models/local/adapters.dart';
import 'package:app/models/remote/auth.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/utils/_index.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

abstract class HiveService {
  Future<void> initBoxes();
  void clearPrefs();
  void clearBox();

  void persistToken(String token);
  String? retrieveToken();
  bool isLoggedOut();

  void persistProfile(PRFUser profile);
  PRFUser? retrieveProfile();
  PRFMember? retrieveMember();
  List<String>? retrieveMemberGroupUlids();
  String retrieveStudentUlid();
  void persistStudentCredentials({
    required String email,
    int? password,
  });
  (String email, int? password) retrieveStudentCredentials();

  void persistClassGroups(PRFClassGroupResponse classGroups);
  List<PRFClassGroup> retrieveClassGroups();

  void persistSouls(PRFSoulResponse souls, String missionUlid);
  void persistSoul(PRFSoul soul, String missionUlid);
  List<PRFSoul> retrieveSouls(String missionUlid);
  void clearSouls(String missionUlid);

  void persistExpenseCategories(PRFExpenseCategoryResponse expenseCategories);
  List<PRFExpenseCategory> retrieveExpenseCategories();
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
    await Hive.openBox<dynamic>(
      PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
    );
  }

  @override
  void clearPrefs() {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .deleteAll(<String>[
      'accessToken',
      'profile',
      'classGroups',
      'studentCredentials',
    ]);
  }

  @override
  void clearBox() {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox).clear();
  }

  @override
  void persistToken(String token) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox).put(
      'tokenExpiryTime',
      DateTime.now().add(const Duration(days: 3)).toString(),
    );

    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('accessToken', token);

    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.globalHiveAuthBox)
        .put('isLoggedOut', false);
  }

  @override
  String? retrieveToken() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final accessToken = box.get('accessToken') as String?;
    if (accessToken == null) return null;

    final expiryTime = box.get('tokenExpiryTime') as String?;
    if (expiryTime == null) return null;

    final expiry = DateTime.parse(expiryTime);
    if (DateTime.now().isAfter(expiry)) {
      clearPrefs();
      Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.globalHiveAuthBox)
          .put('isLoggedOut', true);
      return null;
    }

    return accessToken;
  }

  @override
  bool isLoggedOut() {
    return Hive.box<dynamic>(
          PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
        ).get('isLoggedOut') as bool? ??
        false;
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
  List<String>? retrieveMemberGroupUlids() {
    return retrieveMember()!
            .groupMembers
            ?.map((groupMember) => groupMember.group!.ulid)
            .toList() ??
        [];
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

  @override
  String retrieveStudentUlid() {
    final profile = retrieveProfile();
    if (profile == null) return '';
    return profile.student!.ulid;
  }

  @override
  void persistStudentCredentials({
    required String email,
    int? password,
  }) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('studentCredentials', [email, password]);
  }

  @override
  (String, int?) retrieveStudentCredentials() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final credentials = box.get('studentCredentials') as List<dynamic>?;
    if (credentials == null) return ('', null);
    return (credentials[0] as String, credentials[1] as int?);
  }

  @override
  void persistExpenseCategories(PRFExpenseCategoryResponse expenseCategories) {
    Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
        .put('expenseCategories', expenseCategories);
  }

  @override
  List<PRFExpenseCategory> retrieveExpenseCategories() {
    final box = Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox);
    final expenseCategories =
        box.get('expenseCategories') as PRFExpenseCategoryResponse?;
    if (expenseCategories == null) return [];
    return expenseCategories.data;
  }
}
