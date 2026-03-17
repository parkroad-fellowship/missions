import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

/// Read-only view showing the mission's financial allocation summary.
/// Members can see how funds are intended to be used (credits, debits,
/// balance, refunds) from the mission's accounting event.
class RequisitionsView extends StatelessWidget {
  const RequisitionsView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: 'KES ',
      decimalDigits: 0,
    );

    return BlocBuilder<MissionResourceCubit, ResourceState<PRFMission>>(
      builder: (context, state) {
        final mission = state.maybeWhen(
          listLoaded: (items, _, _) =>
              items.firstWhereOrNull((m) => m.ulid == missionUlid),
          mutated: (items, _, _) =>
              items.firstWhereOrNull((m) => m.ulid == missionUlid),
          orElse: () => null,
        );

        final accountingEvent = mission?.accountingEvent;

        if (accountingEvent == null) {
          return const PRFEmptyView(
            label: 'Requisitions',
            description: 'No financial data available for this mission.',
            icon: Icons.receipt_long_outlined,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          children: [
            // Financial Summary Card
            Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      Text(
                        'Fund Allocation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  _buildFinancialRow(
                    context,
                    label: 'Budget (Credits)',
                    value: currencyFormat.format(accountingEvent.credits),
                    color: PRFColors.success,
                  ),
                  const Divider(height: PRFSpacingTokens.xl),
                  _buildFinancialRow(
                    context,
                    label: 'Spent (Debits)',
                    value: currencyFormat.format(accountingEvent.debits),
                    color: theme.colorScheme.error,
                  ),
                  const Divider(height: PRFSpacingTokens.xl),
                  _buildFinancialRow(
                    context,
                    label: 'Balance',
                    value: currencyFormat.format(accountingEvent.balance),
                    color: accountingEvent.balance >= 0
                        ? PRFColors.success
                        : theme.colorScheme.error,
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.lg),

            // Refund Info Card
            if (accountingEvent.amountToRefund > 0 ||
                accountingEvent.refunds.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.currency_exchange_outlined,
                          size: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: PRFSpacingTokens.sm),
                        Text(
                          'Refunds',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PRFSpacingTokens.lg),
                    _buildFinancialRow(
                      context,
                      label: 'Refund Charge',
                      value: currencyFormat.format(
                        accountingEvent.refundCharge,
                      ),
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const Divider(height: PRFSpacingTokens.xl),
                    _buildFinancialRow(
                      context,
                      label: 'Amount to Refund',
                      value: currencyFormat.format(
                        accountingEvent.amountToRefund,
                      ),
                      color: theme.colorScheme.primary,
                      isBold: true,
                    ),
                    if (accountingEvent.refunds.isNotEmpty) ...[
                      const Divider(height: PRFSpacingTokens.xl),
                      Text(
                        '${accountingEvent.refunds.length} refund(s) processed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: PRFSpacingTokens.lg),

            // Due date
            Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Text(
                    'Due: ${DateFormat.yMMMd().format(accountingEvent.dueDate)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFinancialRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: isBold ? FontWeight.w600 : null,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
