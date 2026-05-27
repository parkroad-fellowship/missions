import 'package:app/features/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/cubit/delete_receipt_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/requisitions/cubit/requisition_resource_cubit.dart';
import 'package:app/services/api/accounting_event_service.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/api/refund_service.dart';
import 'package:app/services/api/requisition_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for mission expenses and requisitions.
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
