import 'package:app/features/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class DeleteExpenseDialog extends StatelessWidget {
  const DeleteExpenseDialog({
    required this.entry,
    super.key,
  });

  final PRFAllocationEntry entry;

  static Future<bool?> show(
    BuildContext context, {
    required PRFAllocationEntry entry,
  }) {
    return PRFConfirmationDialog.show(
      context,
      title: 'Delete Expense',
      message:
          'Are you sure you want to delete this expense? '
          'This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      AllocationEntryResourceCubit,
      ResourceState<PRFAllocationEntry>
    >(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          mutated: (_, _, _) {
            Navigator.of(context).pop(true);
          },
          error: (message, _) {
            Navigator.of(context).pop(false);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
