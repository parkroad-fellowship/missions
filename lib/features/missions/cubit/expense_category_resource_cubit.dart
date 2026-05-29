import 'package:app/models/remote/expense/prf_expense_category.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ExpenseCategoryResourceCubit extends ResourceCubit<PRFExpenseCategory> {
  ExpenseCategoryResourceCubit({
    required ExpenseCategoriesService expenseCategoriesService,
    required HiveService hiveService,
  }) : super(
         service: expenseCategoriesService,
         dbService: hiveService.expenseCategories,
       );
}
