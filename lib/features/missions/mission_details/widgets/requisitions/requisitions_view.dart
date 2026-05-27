import 'package:app/enums/expense/prf_approval_status.dart';
import 'package:app/features/missions/mission_details/widgets/requisitions/cubit/requisition_resource_cubit.dart';
import 'package:app/models/remote/expense/prf_requisition.dart';
import 'package:app/models/remote/expense/prf_requisition_item.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

/// Read-only view showing the mission's financial allocation summary and
/// requisition line items so members can see how mission funds are allocated.
class RequisitionsView extends StatefulWidget {
  const RequisitionsView({required this.accountingEventUlid, super.key});

  final String? accountingEventUlid;

  @override
  State<RequisitionsView> createState() => _RequisitionsViewState();
}

class _RequisitionsViewState extends State<RequisitionsView> {
  final _currencyFormat = NumberFormat.currency(
    symbol: 'KES ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadRequisitions();
  }

  Future<void> _loadRequisitions() async {
    if (widget.accountingEventUlid != null) {
      await context.read<RequisitionResourceCubit>().loadForAccountingEvent(
        accountingEventUlid: widget.accountingEventUlid!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.accountingEventUlid == null
        ? const PRFEmptyView(
            label: 'Requisitions',
            description: 'No financial data available for this mission.',
            icon: Icons.receipt_long_outlined,
          )
        : BlocBuilder<RequisitionResourceCubit, ResourceState<PRFRequisition>>(
            builder: (context, requisitionState) {
              return requisitionState.when(
                initial: () => const SizedBox.shrink(),
                listLoading: (_) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(PRFSpacingTokens.xxl),
                    child: PRFCircularProgressIndicator(),
                  ),
                ),
                itemLoading: (_, _) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(PRFSpacingTokens.xxl),
                    child: PRFCircularProgressIndicator(),
                  ),
                ),
                listLoaded: (requisitions, _, _) => _buildContent(
                  context,

                  requisitions: requisitions,
                ),
                itemLoaded: (_, requisitions) => _buildContent(
                  context,

                  requisitions: requisitions,
                ),
                mutating: (requisitions, _) => _buildContent(
                  context,

                  requisitions: requisitions,
                ),
                mutated: (requisitions, _, _) => _buildContent(
                  context,

                  requisitions: requisitions,
                ),
                error: (message, requisitions) => _buildContent(
                  context,

                  requisitions: requisitions,
                  errorMessage: message,
                ),
                itemError: (message, requisitions, _) => _buildContent(
                  context,

                  requisitions: requisitions,
                  errorMessage: message,
                ),
              );
            },
          );
  }

  Widget _buildContent(
    BuildContext context, {
    required List<PRFRequisition> requisitions,
    String? errorMessage,
  }) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      children: [
        // Error message
        if (errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            ),
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
        ],

        // Requisitions list
        if (requisitions.isEmpty)
          const PRFEmptyView(
            label: 'No Requisitions',
            description: 'No requisitions have been created for this mission.',
            icon: Icons.receipt_long_outlined,
          )
        else
          ...requisitions.map(
            (requisition) => _buildRequisitionCard(context, requisition),
          ),
      ],
    );
  }

  Widget _buildRequisitionCard(
    BuildContext context,
    PRFRequisition requisition,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: PRFColors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
            ),
            childrenPadding: const EdgeInsets.only(
              left: PRFSpacingTokens.lg,
              right: PRFSpacingTokens.lg,
              bottom: PRFSpacingTokens.lg,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(requisition.requisitionDate),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: PRFSpacingTokens.xs),
                      Text(
                        _currencyFormat.format(requisition.totalAmount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context, requisition.approvalStatus),
              ],
            ),
            children: [
              if (requisition.remarks != null &&
                  requisition.remarks!.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    requisition.remarks!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
              ],
              if (requisition.approvalNotes != null &&
                  requisition.approvalNotes!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                  decoration: BoxDecoration(
                    color: requisition.approvalStatus
                        .color(theme)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  child: Text(
                    'Note: ${requisition.approvalNotes}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
              ],
              if (requisition.requisitionItems.isEmpty)
                Text(
                  'No line items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ...requisition.requisitionItems.map(
                  (item) => _buildLineItem(context, item),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineItem(
    BuildContext context,
    PRFRequisitionItem item,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
      child: Container(
        padding: const EdgeInsets.all(PRFSpacingTokens.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _currencyFormat.format(item.totalPrice),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.xs),
            Text(
              '${_currencyFormat.format(item.unitPrice)} x ${item.quantity}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (item.expenseCategory != null) ...[
              const SizedBox(height: PRFSpacingTokens.xs),
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: PRFSpacingTokens.xs),
                  Text(
                    item.expenseCategory!.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            if (item.narration != null && item.narration!.isNotEmpty) ...[
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                item.narration!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    PRFApprovalStatus status,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: status.color(theme).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 14,
            color: status.color(theme),
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            status.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: status.color(theme),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
