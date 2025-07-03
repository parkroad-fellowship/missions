import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class ExpenseHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

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

  void clearExpenseCategories() {
    delete('expenseCategories');
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

  void clearMissionExpense(String missionUlid) {
    deleteCollection('mission-expenses', missionUlid);
  }

  void clearAllExpenses() {
    deleteAll(['expenseCategories']);
    final keys = box.keys.where((key) => key.toString().startsWith('mission-expenses-'));
    deleteAll(keys.map((key) => key.toString()).toList());
  }
}