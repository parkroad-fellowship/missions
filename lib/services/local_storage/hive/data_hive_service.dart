import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class DataHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  // Class Groups
  void persistClassGroups(PRFClassGroupResponse classGroups) {
    put('classGroups', classGroups);
  }

  List<PRFClassGroup> retrieveClassGroups() {
    final classGroups = get<PRFClassGroupResponse>('classGroups');
    if (classGroups == null) return [];
    return classGroups.data;
  }

  // Souls
  void persistSouls(PRFSoulResponse souls, String missionUlid) {
    putCollection('souls', missionUlid, souls);
  }

  void persistSoul(PRFSoul soul, String missionUlid) {
    final souls = getCollection<PRFSoulResponse>('souls', missionUlid);
    if (souls == null) return;

    final modified = List<PRFSoul>.from(souls.data)..add(soul);
    putCollection('souls', missionUlid, PRFSoulResponse(data: modified));
  }

  List<PRFSoul> retrieveSouls(String missionUlid) {
    final souls = getCollection<PRFSoulResponse>('souls', missionUlid);
    if (souls == null) return [];
    return souls.data.reversed.toList();
  }

  void clearSouls(String missionUlid) {
    deleteCollection('souls', missionUlid);
  }

  // Expense Categories
  void persistExpenseCategories(PRFExpenseCategoryResponse expenseCategories) {
    put('expenseCategories', expenseCategories);
  }

  List<PRFExpenseCategory> retrieveExpenseCategories() {
    final expenseCategories = get<PRFExpenseCategoryResponse>(
      'expenseCategories',
    );
    if (expenseCategories == null) return [];
    return expenseCategories.data;
  }

  // Mission Expenses
  void persistMissionExpense(
    PRFMissionExpense missionExpense,
    String missionUlid,
  ) {
    putCollection('mission-expenses', missionUlid, missionExpense);
  }

  PRFMissionExpense? retrieveMissionExpense(String missionUlid) {
    return getCollection<PRFMissionExpense>('mission-expenses', missionUlid);
  }

  void persistExpense(PRFExpense expense, String missionUlid) {
    final missionExpense = retrieveMissionExpense(missionUlid);
    if (missionExpense == null) return;

    final modified = List<PRFExpense>.from(missionExpense.expenses)
      ..add(expense);
    persistMissionExpense(
      missionExpense.copyWith(expenses: modified),
      missionUlid,
    );
  }

  // Payment Types
  void persistPaymentTypes(PRFPaymentTypeResponse paymentTypes) {
    put('paymentTypes', paymentTypes);
  }

  List<PRFPaymentType> retrievePaymentTypes() {
    final paymentTypes = get<PRFPaymentTypeResponse>('paymentTypes');
    if (paymentTypes == null) return [];
    return paymentTypes.data;
  }

  // Clear data
  void clearDataCache() {
    deleteAll([
      'classGroups',
      'expenseCategories',
      'paymentTypes',
    ]);
  }
}
