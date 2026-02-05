import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/add_allocation_entry_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/add_allocation_token_entry_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/add_mission_refund_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/delete_allocation_entry_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/delete_receipt_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/edit_allocation_entry_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/get_allocation_entries_cubit.dart';
import 'package:app/services/api/accounting_event_service.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/api/refund_service.dart';
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
      ..registerSingleton<RefundService>(RefundService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<GetExpenseCategoriesCubit>(
        create: (context) => GetExpenseCategoriesCubit(
          expenseCategoriesService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetAllocationEntriesCubit>(
        create: (context) => GetAllocationEntriesCubit(
          allocationEntryService: getIt(),
        ),
      ),
      BlocProvider<AddAllocationEntryCubit>(
        create: (context) => AddAllocationEntryCubit(
          allocationEntryService: getIt(),
          hiveService: getIt(),
          mediaService: getIt(),
        ),
      ),
      BlocProvider<AddAllocationTokenEntryCubit>(
        create: (context) => AddAllocationTokenEntryCubit(
          allocationEntryService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<DeleteAllocationEntryCubit>(
        create: (context) => DeleteAllocationEntryCubit(
          allocationEntryService: getIt(),
        ),
      ),
      BlocProvider<DeleteReceiptCubit>(
        create: (context) => DeleteReceiptCubit(
          allocationEntryService: getIt(),
        ),
      ),
      BlocProvider<EditAllocationEntryCubit>(
        create: (context) => EditAllocationEntryCubit(
          allocationEntryService: getIt(),
          hiveService: getIt(),
          mediaService: getIt(),
        ),
      ),
      BlocProvider<AddMissionRefundCubit>(
        create: (context) => AddMissionRefundCubit(refundService: getIt()),
      ),
    ];
  }
}
