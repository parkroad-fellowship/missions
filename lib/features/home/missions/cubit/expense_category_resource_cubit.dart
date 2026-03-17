import 'package:app/models/remote/expense/prf_expense_category.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ExpenseCategoryResourceCubit extends ResourceCubit<PRFExpenseCategory> {
  ExpenseCategoryResourceCubit({
    required ExpenseCategoriesService expenseCategoriesService,
    BaseLocalDBService<PRFExpenseCategory, dynamic>? dbService,
  }) : super(service: expenseCategoriesService, dbService: dbService);

  @override
  int? get defaultLimit => 100;
}
