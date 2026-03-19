import 'package:app/features/home/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/delete_receipt_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/requisitions/cubit/requisition_resource_cubit.dart';
import 'package:app/services/api/accounting_event_service.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/api/refund_service.dart';
import 'package:app/services/api/requisition_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Expenses module for registering expense/accounting-related services and cubits.
///
/// Includes:
/// - Expense categories
/// - Allocation entries
/// - Refunds
/// - Accounting events
class ExpensesModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<ExpenseCategoriesService>(ExpenseCategoriesService())
      ..registerSingleton<AccountingEventService>(AccountingEventService())
      ..registerSingleton<AllocationEntryService>(AllocationEntryService())
      ..registerSingleton<RefundService>(RefundService())
      ..registerSingleton<RequisitionService>(RequisitionService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<ExpenseCategoryResourceCubit>(
        create: (context) => ExpenseCategoryResourceCubit(
          expenseCategoriesService: getIt(),
        ),
      ),
      BlocProvider<AllocationEntryResourceCubit>(
        create: (context) => AllocationEntryResourceCubit(
          allocationEntryService: getIt(),
          mediaService: getIt(),
          hiveService: getIt(),
          refundService: getIt(),
        ),
      ),
      // Keep-as-is: DeleteReceiptCubit (specialized receipt deletion)
      BlocProvider<DeleteReceiptCubit>(
        create: (context) => DeleteReceiptCubit(
          allocationEntryService: getIt(),
        ),
      ),
      BlocProvider<RequisitionResourceCubit>(
        create: (context) => RequisitionResourceCubit(
          requisitionService: getIt(),
        ),
      ),
    ];
  }
}
