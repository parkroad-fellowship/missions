import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/services/local_storage/hive/models/class_group_hive_service.dart';
import 'package:app/services/local_storage/hive/models/expense_hive_service.dart';
import 'package:app/services/local_storage/hive/models/payment_type_hive_service.dart';
import 'package:app/services/local_storage/hive/models/soul_hive_service.dart';
import 'package:app/utils/_index.dart';

class DataHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  // Model-specific services
  late final ClassGroupHiveService _classGroups;
  late final SoulHiveService _souls;
  late final ExpenseHiveService _expenses;
  late final PaymentTypeHiveService _payments;

  // Initialize sub-services
  void initialize() {
    _classGroups = ClassGroupHiveService();
    _souls = SoulHiveService();
    _expenses = ExpenseHiveService();
    _payments = PaymentTypeHiveService();
  }

  // Getters for sub-services
  ClassGroupHiveService get classGroups => _classGroups;
  SoulHiveService get souls => _souls;
  ExpenseHiveService get expenses => _expenses;
  PaymentTypeHiveService get payments => _payments;

  // Convenience methods that delegate to sub-services
  List<PRFClassGroup> retrieveClassGroups() =>
      _classGroups.retrieveClassGroups();
  List<PRFSoul> retrieveSouls(String missionUlid) =>
      _souls.retrieveSouls(missionUlid);
  List<PRFExpenseCategory> retrieveExpenseCategories() =>
      _expenses.retrieveExpenseCategories();
  List<PRFPaymentType> retrievePaymentTypes() =>
      _payments.retrievePaymentTypes();

  // Clear all data
  void clearDataCache() {
    _classGroups.clearClassGroups();
    _expenses.clearAllExpenses();
    _payments.clearPaymentTypes();
    _souls.clearAllSouls();
  }
}
