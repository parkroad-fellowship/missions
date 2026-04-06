import 'package:app/models/remote/expense/prf_expense_category.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ExpenseCategoryResourceCubit
    extends ResourceCubit<PRFExpenseCategory, Null> {
  ExpenseCategoryResourceCubit({
    required ExpenseCategoriesService expenseCategoriesService,
    super.dbService,
  }) : super(service: expenseCategoriesService);

  @override
  int? get defaultLimit => 100;
}
