// ignore_for_file: lines_longer_than_80_chars

import 'package:app/enums/mission/prf_entry_type.dart';
import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/add_expense/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/add_refund/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/add_token/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/edit_expense/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/delete_receipt_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/receipt_preview.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/actions/add_media/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/models/remote/expense/prf_refund.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class ExpensesViewHandset extends StatefulWidget {
  const ExpensesViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<ExpensesViewHandset> createState() => _ExpensesViewHandsetState();
}

class _ExpensesViewHandsetState extends State<ExpensesViewHandset>
    with TimezoneMixin {
  bool _showBreakdown = true;
  String get missionUlid => widget.missionUlid;

  String? accountingEventUlid;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Don't re-fetch mission — parent already loaded it.
    // Extract accountingEventUlid from existing cubit state.
    final missionState = context.read<MissionResourceCubit>().state;
    final mission = missionState.maybeWhen(
      listLoaded: (items, _, _) => items.firstWhereOrNull(
        (m) => m.ulid == missionUlid,
      ),
      mutated: (items, _, _) => items.firstWhereOrNull(
        (m) => m.ulid == missionUlid,
      ),
      orElse: () => null,
    );

    if (mission != null) {
      accountingEventUlid = mission.accountingEvent?.ulid;
      if (accountingEventUlid != null) {
        context.read<AllocationEntryResourceCubit>().loadAll(
          filters: {'accounting_event_ulid': accountingEventUlid},
        );
      }
    }

    context.read<ExpenseCategoryResourceCubit>().loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<MissionResourceCubit, ResourceState<PRFMission>>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              listLoaded: (missions, _, _) {
                if (missions.isNotEmpty) {
                  final mission = missions.first;
                  accountingEventUlid = mission.accountingEvent?.ulid;
                  if (accountingEventUlid != null) {
                    context.read<AllocationEntryResourceCubit>().loadAll(
                      filters: {
                        'accounting_event_ulid': accountingEventUlid,
                      },
                    );
                  }
                }
              },
              error: (message, _) {
                PRFSnackbar.error(context, 'Failed to load mission: $message');
              },
            );
          },
        ),
        BlocListener<
          AllocationEntryResourceCubit,
          ResourceState<PRFAllocationEntry>
        >(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              mutated: (_, _, _) {
                _loadData();
                PRFSnackbar.success(context, 'Entry added successfully');
              },
              error: (message, _) {
                PRFSnackbar.error(context, message);
              },
            );
          },
        ),
        BlocListener<
          AllocationEntryResourceCubit,
          ResourceState<PRFAllocationEntry>
        >(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              mutated: (_, _, _) {
                _loadData();
                PRFSnackbar.success(context, 'Expense updated successfully');
              },
              error: (message, _) {
                PRFSnackbar.error(context, message);
              },
            );
          },
        ),
        BlocListener<
          AllocationEntryResourceCubit,
          ResourceState<PRFAllocationEntry>
        >(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              mutated: (_, _, _) {
                _loadData();
                PRFSnackbar.success(context, 'Expense deleted successfully');
              },
              error: (message, _) {
                PRFSnackbar.error(context, message);
              },
            );
          },
        ),
        BlocListener<UploadMediaCubit, UploadMediaState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              loaded: () {
                _loadData();
                PRFSnackbar.success(context, 'Receipt uploaded successfully');
              },
              error: (message) {
                PRFSnackbar.error(
                  context,
                  'Failed to upload receipt: $message',
                );
              },
            );
          },
        ),
      ],
      child:
          BlocBuilder<
            AllocationEntryResourceCubit,
            ResourceState<PRFAllocationEntry>
          >(
            builder: (context, state) {
              return state.when(
                initial: () => const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                  ),
                  child: PRFLinearProgressIndicator(),
                ),
                listLoading: () => const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                  ),
                  child: PRFLinearProgressIndicator(),
                ),
                listLoaded: (entries, _, _) {
                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.lg,
                      ),
                      child: PRFEmptyView(
                        label: 'No Expenses Yet',
                        description: 'Start by adding your first expense',
                        icon: Icons.receipt_long_outlined,
                      ),
                    );
                  }
                  return _buildLoadedView(context, l10n, entries);
                },
                mutating: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                  ),
                  child: PRFLinearProgressIndicator(),
                ),
                mutated: (entries, _, _) =>
                    _buildLoadedView(context, l10n, entries),
                error: (message, _) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                  ),
                  child: PRFEmptyView(
                    label: 'Error',
                    description: message,
                    icon: Icons.error_outline,
                    actionLabel: 'Retry',
                    onActionPressed: _loadData,
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildLoadedView(
    BuildContext context,
    AppLocalizations l10n,
    List<PRFAllocationEntry> entries,
  ) {
    final accountingEvent = entries.isNotEmpty
        ? entries.first.accountingEvent
        : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(
            context,
            l10n,
            accountingEvent!,
          ),
        ),
        // Financial Overview Header
        SliverToBoxAdapter(
          child:
              _buildFinancialOverview(
                    context,
                    l10n,
                    accountingEvent,
                  )
                  .animate()
                  .slideY(begin: -0.3)
                  .fadeIn(duration: PRFMotionTokens.enterShort),
        ),

        // Quick Actions
        SliverToBoxAdapter(
          child:
              _buildQuickActions(
                    context,
                    l10n,
                    accountingEvent,
                  )
                  .animate(delay: PRFMotionTokens.standard)
                  .slideY(begin: 0.3)
                  .fadeIn(),
        ),

        // Refund Information (show when balance > 0)
        SliverToBoxAdapter(
          child: _buildRefundInformation(
            context,
            l10n,
            accountingEvent,
          ),
        ),

        // Breakdown Toggle
        SliverToBoxAdapter(
          child: _buildBreakdownToggle(
            context,
            entries,
          ).animate(delay: PRFMotionTokens.slow).slideX(begin: -0.2).fadeIn(),
        ),

        // Expenses List (if breakdown is shown)
        if (_showBreakdown && entries.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildExpenseCard(context, entries[index])
                      .animate()
                      .fadeIn(
                        duration: PRFMotionTokens.slow,
                        delay: (index * 50).ms,
                      )
                      .slideX(begin: 0.2, end: 0);
                },
                childCount: entries.length,
              ),
            ),
          ),

        // Empty state when breakdown is shown but no entries
        if (_showBreakdown && entries.isEmpty)
          SliverToBoxAdapter(
            child: const PRFEmptyView(
              label: 'No Expenses Yet',
              description: 'Start by adding your first expense',
              icon: Icons.receipt_long_outlined,
            ).animate().fadeIn(duration: PRFMotionTokens.enterShort),
          ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildFinancialOverview(
    BuildContext context,
    AppLocalizations l10n,
    PRFAccountingEvent accountingEvent,
  ) {
    final theme = Theme.of(context);
    final spentPercentage = accountingEvent.credits > 0
        ? (accountingEvent.debits / accountingEvent.credits)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
      child: Column(
        children: [
          // Main Balance Card
          Container(
                width: double.infinity,
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.currentBalance,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: PRFColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.md,
                            vertical: PRFSpacingTokens.xs,
                          ),
                          decoration: BoxDecoration(
                            color: PRFColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                          ),
                          child: Text(
                            '${(spentPercentage * 100).toStringAsFixed(1)}% spent',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: PRFColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    Text(
                      NumberFormat.currency(
                        locale: 'en_KE',
                        symbol: 'KES ',
                      ).format(accountingEvent.balance),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: PRFColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.lg),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: PRFColors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: spentPercentage.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: PRFColors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: PRFMotionTokens.enterShort)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: PRFSpacingTokens.lg),

          // Financial Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.amountReceived,
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(accountingEvent.credits),
                  Icons.trending_up,
                  theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.amountSpent,
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(accountingEvent.debits),
                  Icons.trending_down,
                  theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.amountToRefund,
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(
                    accountingEvent.latestRefund?.deficitAmount ??
                        accountingEvent.amountToRefund,
                  ),
                  Icons.refresh,
                  theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                '$title\n',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                '$value\n',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: PRFMotionTokens.standard, duration: PRFMotionTokens.slow)
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildQuickActions(
    BuildContext context,
    AppLocalizations l10n,
    PRFAccountingEvent accountingEvent,
  ) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: Row(
        children: [
          Expanded(
            child: PRFPrimaryButton(
              onPressed: () => _showAddTokenModal(context, accountingEvent),
              title: l10n.addToken,
              disabled: false,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.md),
          Expanded(
            child: PRFSecondaryButton(
              onPressed: () => _showAddExpenseModal(context),
              title: l10n.addExpense,
              disabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownToggle(
    BuildContext context,
    List<PRFAllocationEntry> entries,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        elevation: 1,
        child: InkWell(
          onTap: () => setState(() => _showBreakdown = !_showBreakdown),
          borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            child: Row(
              children: [
                Icon(
                  Icons.list_alt,
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Breakdown',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _showBreakdown
                            ? 'Tap to hide details'
                            : 'Tap to view ${entries.length} transactions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  duration: PRFMotionTokens.standard,
                  turns: _showBreakdown ? 0.5 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, PRFAllocationEntry entry) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isCredit = entry.entryType == PRFEntryType.credit;
    final hasReceipts = entry.receipts.isNotEmpty;
    final missingReceipt = !isCredit && !hasReceipts;

    return Container(
      margin: const EdgeInsets.only(bottom: PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: PRFColors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Category and Amount
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: isCredit
                          ? theme.colorScheme.primaryContainer.withValues(
                              alpha: 0.3,
                            )
                          : theme.colorScheme.errorContainer.withValues(
                              alpha: 0.3,
                            ),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: Icon(
                      isCredit ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isCredit
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.expenseCategory?.name ?? l10n.unknownCategory,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (entry.member?.fullName != null) ...[
                          const SizedBox(height: PRFSpacingTokens.xs),
                          Text(
                            entry.member!.fullName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.currency(
                            symbol: 'KES ',
                            decimalDigits: 0,
                          ).format(entry.amount),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCredit
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          DateFormat('MMM dd, yyyy').format(entry.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  // Delete Button for Debit Entries Only
                  if (!isCredit) ...[
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Material(
                      color: PRFColors.transparent,
                      child: InkWell(
                        onTap: () => _showDeleteConfirmation(context, entry),
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                            border: Border.all(
                              color: theme.colorScheme.error.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                  // Edit Button
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Material(
                    color: PRFColors.transparent,
                    child: InkWell(
                      onTap: () => _showExpenseDetails(context, entry),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      child: Container(
                        padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.smd,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Description Row (if exists)
              if (entry.narration.isNotEmpty) ...[
                const SizedBox(height: PRFSpacingTokens.sm),
                Text(
                  entry.narration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: PRFSpacingTokens.md),

              if (hasReceipts) ...[
                _buildReceiptAttachments(context, entry.ulid, entry.receipts),
              ] else if (missingReceipt) ...[
                _buildMissingReceiptAction(context, entry),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptAttachments(
    BuildContext context,
    String allocationEntryUlid,
    List<PRFMedia> receipts,
  ) {
    final theme = Theme.of(context);

    return BlocListener<DeleteReceiptCubit, DeleteReceiptState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: (mediaUuid) {},
          loaded: (mediaUuid) {
            _loadData();
            PRFSnackbar.success(context, 'Receipt deleted successfully');
          },
          error: (message) {
            PRFSnackbar.error(context, message);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.sm),
                Text(
                  '${receipts.length} '
                  'Attachment${receipts.length == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: receipts.length,
                itemBuilder: (context, index) {
                  final receipt = receipts[index];
                  final isPdf = receipt.temporaryURL.toLowerCase().contains(
                    '.pdf',
                  );

                  return BlocBuilder<DeleteReceiptCubit, DeleteReceiptState>(
                    builder: (context, state) {
                      final isDeleting = state.maybeWhen(
                        loading: (mediaUuid) => mediaUuid == receipt.uuid,
                        orElse: () => false,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: PRFSpacingTokens.md,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: isPdf
                                  ? () => _openPdfDocument(
                                      context,
                                      receipt.temporaryURL,
                                    )
                                  : () => _showReceiptPreview(
                                      context,
                                      receipts,
                                      index,
                                    ),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.md,
                                  ),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(
                                            alpha: 0.1,
                                          ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isPdf
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.tertiary
                                              .withValues(
                                                alpha: 0.2,
                                              ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_present,
                                              size: 28,
                                              color: theme.colorScheme.tertiary,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'PDF',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              receipt.temporaryURL,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return ColoredBox(
                                                      color: theme
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: theme
                                                            .colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                        size: 24,
                                                      ),
                                                    );
                                                  },
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return ColoredBox(
                                                      color: theme
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                      child: Center(
                                                        child: SizedBox(
                                                          width:
                                                              PRFSpacingTokens
                                                                  .xl,
                                                          height: 20,
                                                          child: PRFCircularProgressIndicator(
                                                            color: theme
                                                                .colorScheme
                                                                .primary,
                                                            value:
                                                                loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                            // Overlay for better tap indication
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      PRFColors.transparent,
                                                      PRFColors.black.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            // Delete button
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () => _showDeleteReceiptConfirmation(
                                  context,
                                  allocationEntryUlid,
                                  receipt,
                                ),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.surface,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: theme.colorScheme.onError,
                                  ),
                                ),
                              ),
                            ),
                            // Loading overlay during deletion
                            if (isDeleting)
                              Positioned.fill(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: PRFColors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.md,
                                    ),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: PRFSpacingTokens.xl,
                                      height: 20,
                                      child: PRFCircularProgressIndicator(
                                        color: PRFColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteReceiptConfirmation(
    BuildContext context,
    String allocationEntryUlid,
    PRFMedia receipt,
  ) {
    PRFConfirmationDialog.show(
      context,
      title: 'Delete Receipt',
      message:
          'Are you sure you want to delete this receipt? This action cannot '
          'be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
      onConfirm: () {
        context.read<DeleteReceiptCubit>().deleteReceipt(
          allocationEntryUlid: allocationEntryUlid,
          mediaUuid: receipt.uuid,
        );
      },
    );
  }

  Widget _buildMissingReceiptAction(
    BuildContext context,
    PRFAllocationEntry entry,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
            ),
            child: Icon(
              Icons.receipt_outlined,
              size: 20,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt Missing',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Attach receipt or documentation',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<UploadMediaCubit, UploadMediaState>(
            builder: (context, uploadState) {
              return uploadState.maybeWhen(
                orElse: () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Attach Image Button
                    Material(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      child: InkWell(
                        onTap: () async {
                          try {
                            await context
                                .read<SelectMediaCubit>()
                                .selectMediaWithSource(
                                  context: context,
                                  modelUlid: entry.ulid,
                                  model: PRFMediaModel.allocationEntryReceipts,
                                  mediaType: MediaType.photos,
                                );

                            // Get the selected media from the cubit state
                            // ignore: use_build_context_synchronously
                            context.read<SelectMediaCubit>().state.maybeWhen(
                              orElse: () {},
                              loaded: (_) {
                                if (context.mounted) {
                                  context
                                      .read<UploadMediaCubit>()
                                      .uploadMedia();
                                }
                              },
                            );
                          } catch (e) {
                            if (context.mounted) {
                              PRFSnackbar.error(
                                context,
                                'Failed to select image: $e',
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.md,
                            vertical: PRFSpacingTokens.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 16,
                                color: theme.colorScheme.onError,
                              ),
                              const SizedBox(width: PRFSpacingTokens.xs),
                              Text(
                                'Image',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    // Attach PDF Button
                    Material(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      child: InkWell(
                        onTap: () async {
                          try {
                            await context
                                .read<SelectMediaCubit>()
                                .selectDocuments(
                                  modelUlid: entry.ulid,
                                  model: PRFMediaModel.allocationEntryReceipts,
                                );

                            // Get the selected documents from the cubit state
                            // ignore: use_build_context_synchronously
                            context.read<SelectMediaCubit>().state.maybeWhen(
                              orElse: () {},
                              loaded: (_) {
                                if (context.mounted) {
                                  context
                                      .read<UploadMediaCubit>()
                                      .uploadMedia();
                                }
                              },
                            );
                          } catch (e) {
                            if (context.mounted) {
                              PRFSnackbar.error(
                                context,
                                'Failed to select PDF: $e',
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.md,
                            vertical: PRFSpacingTokens.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.file_present_outlined,
                                size: 16,
                                color: theme.colorScheme.onTertiary,
                              ),
                              const SizedBox(width: PRFSpacingTokens.xs),
                              Text(
                                'PDF',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => SizedBox(
                  width: PRFSpacingTokens.lg,
                  height: 16,
                  child: PRFCircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openPdfDocument(BuildContext context, String pdfUrl) {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (context) => PDFViewerPage(
          pdfUrl: pdfUrl,
          title: 'Receipt PDF',
        ),
      ),
    );
  }

  void _showReceiptPreview(
    BuildContext context,
    List<PRFMedia> receipts,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (context) => ReceiptPreviewPage(
          receipts: receipts,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _showAddExpenseModal(BuildContext context) {
    context.read<SelectMediaCubit>().clearMedia();
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Expense',
      child: accountingEventUlid != null
          ? AddExpenseViewHandset(
              accountingEventUlid: accountingEventUlid!,
            )
          : const SizedBox.shrink(),
    );
  }

  void _showExpenseDetails(BuildContext context, PRFAllocationEntry entry) {
    PRFBottomSheet.show<void>(
      context,
      title: 'Edit Expense',
      child: EditExpenseViewHandset(
        allocationEntry: entry,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    PRFAllocationEntry entry,
  ) async {
    final confirmed = await PRFConfirmationDialog.show(
      context,
      title: 'Delete Expense',
      message: 'Are you sure you want to delete this expense?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    await context.read<AllocationEntryResourceCubit>().deleteEntry(entry.ulid);
  }

  void _showAddTokenModal(
    BuildContext context,
    PRFAccountingEvent accountingEvent,
  ) {
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Token',
      child: AddTokenViewHandset(
        accountingEventUlid: accountingEvent.ulid,
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<AllocationEntryResourceCubit>().loadAll(
          filters: {'accounting_event_ulid': accountingEvent.ulid},
        );
      }
    });
  }

  void _showAddRefundModal(
    BuildContext context,
    PRFAccountingEvent accountingEvent,
  ) {
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Refund',
      child: AddRefundViewHandset(
        accountingEventUlid: accountingEvent.ulid,
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<AllocationEntryResourceCubit>().loadAll(
          filters: {'accounting_event_ulid': accountingEvent.ulid},
        );
      }
    });
  }

  Widget _buildRefundInformation(
    BuildContext context,
    AppLocalizations l10n,
    PRFAccountingEvent accountingEvent,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
      child:
          Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      theme.colorScheme.tertiary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.sm,
                            ),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: theme.colorScheme.tertiary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: PRFSpacingTokens.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.refundInformation,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              Text(
                                l10n.refundDesc,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.md,
                            vertical: PRFSpacingTokens.xs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                          ),
                          child: Text(
                            NumberFormat.currency(
                              locale: 'en_KE',
                              symbol: 'KES ',
                            ).format(
                              accountingEvent.latestRefund?.deficitAmount ??
                                  accountingEvent.amountToRefund,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: PRFColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PRFSpacingTokens.lg),
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.payment,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Text(
                                l10n.refundDetails,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: PRFSpacingTokens.md),
                          _buildRefundDetailRow(
                            context,
                            l10n.paybillNumber,
                            '4088159',
                            Icons.numbers,
                          ),
                          const SizedBox(height: PRFSpacingTokens.sm),
                          _buildRefundDetailRow(
                            context,
                            l10n.accountNumber,
                            'REFUND',
                            Icons.account_balance,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: PRFSpacingTokens.sm),
                          Expanded(
                            child: Text(
                              l10n.refundText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    PRFPrimaryButton(
                      onPressed: () =>
                          _showAddRefundModal(context, accountingEvent),
                      title: 'Add Refund',
                      disabled: false,
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    if (accountingEvent.refunds.isNotEmpty)
                      _buildRefundEntriesList(
                        context,
                        theme,
                        accountingEvent.refunds,
                      ),
                    if (accountingEvent.refunds.isNotEmpty)
                      const SizedBox(height: PRFSpacingTokens.md),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: PRFMotionTokens.enterShort)
              .slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildRefundEntriesList(
    BuildContext context,
    ThemeData theme,
    List<PRFRefund> refunds,
  ) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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
                Icons.receipt_long,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: PRFSpacingTokens.sm),
              Text(
                'Refund Entries',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.sm,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Text(
                  '${refunds.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: refunds.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              height: 16,
            ),
            itemBuilder: (context, index) {
              final refund = refunds.reversed.elementAt(index);
              return _buildRefundEntryItem(context, theme, refund, index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRefundEntryItem(
    BuildContext context,
    ThemeData theme,
    PRFRefund refund,
    int entryNumber,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.sm,
                vertical: PRFSpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.xs),
              ),
              child: Text(
                '#$entryNumber',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_KE',
                      symbol: 'KES ',
                    ).format(refund.amount),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        _buildRefundDetailValue(
          context,
          theme,
          'Deficit Amount',
          NumberFormat.currency(locale: 'en_KE', symbol: 'KES ').format(
            refund.deficitAmount,
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        _buildRefundDetailValue(
          context,
          theme,
          'Confirmation',
          refund.confirmationMessage,
          isCopyable: true,
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        _buildRefundDetailValue(
          context,
          theme,
          'Date',
          DateFormatter.formatDateTime(refund.createdAt, timezone),
        ),
      ],
    );
  }

  Widget _buildRefundDetailValue(
    BuildContext context,
    ThemeData theme,
    String label,
    String value, {
    bool isCopyable = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              PRFSnackbar.info(context, 'Copied to clipboard');
            },
            icon: Icon(
              Icons.copy,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            padding: const EdgeInsets.all(PRFSpacingTokens.xs),
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildRefundDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: PRFSpacingTokens.sm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            PRFSnackbar.info(context, 'Copied "$value" to clipboard');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.sm,
              vertical: PRFSpacingTokens.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.xs),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.xs),
                Icon(
                  Icons.copy,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    PRFAccountingEvent accountingEvent,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.expenseTracking,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.xs),
                Text(
                  l10n.financialOverview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<
            AllocationEntryResourceCubit,
            ResourceState<PRFAllocationEntry>
          >(
            builder: (context, state) {
              return IconButton.filled(
                onPressed: () =>
                    context.read<AllocationEntryResourceCubit>().loadAll(
                      filters: {
                        'accounting_event_ulid': accountingEvent.ulid,
                      },
                    ),
                icon: state.maybeWhen(
                  orElse: () => const Icon(
                    Icons.refresh,
                    color: PRFColors.white,
                  ),
                  listLoading: () => const SizedBox(
                    width: PRFSpacingTokens.xl,
                    height: 20,
                    child: PRFCircularProgressIndicator(),
                  ),
                  listLoaded: (_, _, _) => const Icon(
                    Icons.refresh,
                    color: PRFColors.white,
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
