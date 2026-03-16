import 'package:app/enums/payment/prf_payment_status.dart';
import 'package:app/features/home/giving/actions/add_payment/add_payment.dart';
import 'package:app/features/home/giving/cubit/get_payments_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GivingPageTablet extends StatefulWidget {
  const GivingPageTablet({super.key});

  @override
  State<GivingPageTablet> createState() => _GivingPageTabletState();
}

class _GivingPageTabletState extends State<GivingPageTablet> {
  @override
  void initState() {
    super.initState();
    context.read<GetPaymentsCubit>().getPayments();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.give,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              backgroundColor: theme.colorScheme.surface,
              actions: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                    boxShadow: [
                      BoxShadow(
                        color: PRFColors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () =>
                        context.read<GetPaymentsCubit>().getPayments(),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SliverToBoxAdapter(child: SizedBox(height: PRFSpacingTokens.xxl)),

            // Loading Indicator
            SliverToBoxAdapter(
              child: BlocBuilder<GetPaymentsCubit, GetPaymentsState>(
                builder: (context, state) => state.maybeWhen(
                  orElse: () => const PRFLinearProgressIndicator(),
                  error: (message) => const SizedBox.shrink(),
                  loaded: (_) => const SizedBox.shrink(),
                ),
              ),
            ),

            BlocBuilder<GetPaymentsCubit, GetPaymentsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (message) => SliverFillRemaining(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<GetPaymentsCubit>().getPayments(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 80,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: PRFSpacingTokens.xl),
                              Text(
                                message,
                                style: theme.textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  empty: () => SliverFillRemaining(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<GetPaymentsCubit>().getPayments(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          child: PRFEmptyView(
                            label: l10n.considerGiving,
                            description: l10n.startGiving,
                            icon: Icons.volunteer_activism_rounded,
                            actionLabel: l10n.give,
                            onActionPressed: _addPayment,
                          ),
                        ),
                      ),
                    ),
                  ),
                  loaded: (payments) => SliverPadding(
                    padding: const EdgeInsets.only(
                      left: PRFSpacingTokens.xl,
                      right: PRFSpacingTokens.xl,
                      bottom: 120,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.8,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final payment = payments[index];
                          return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.xs,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
                                  child: InkWell(
                                    onTap: () => _showPaymentActions(payment),
                                    borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
                                    splashColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    highlightColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.05),
                                    child: PaymentCard(payment: payment),
                                  ),
                                ),
                              )
                              .animate(
                                delay: Duration(milliseconds: index * 100),
                              )
                              .fadeIn(
                                duration: PRFMotionTokens.enterShort,
                              )
                              .slideY(
                                begin: 0.3,
                                end: 0,
                                duration: PRFMotionTokens.enterShort,
                                curve: Curves.easeOutCubic,
                              )
                              .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1, 1),
                                duration: PRFMotionTokens.enterShort,
                                curve: Curves.easeOutCubic,
                              );
                        },
                        childCount: payments.length,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child:
            FloatingActionButton.extended(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              onPressed: _addPayment,
              icon: const Icon(Icons.add_rounded, size: 24),
              label: Text(
                l10n.give,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              extendedPadding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.xl,
                vertical: PRFSpacingTokens.lg,
              ),
            ).animate(
              effects: [
                const ShimmerEffect(
                  duration: Duration(seconds: 2),
                  delay: PRFMotionTokens.enterShort,
                ),
                const ScaleEffect(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1, 1),
                  duration: PRFMotionTokens.slow,
                ),
              ],
            ),
      ),
    );
  }

  void _addPayment() =>
      WoltModalSheet.show<void>(
        context: context,
        pageListBuilder: (modalSheetContext) {
          return [
            WoltModalSheetPage(
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: const AddPaymentView(),
              ),
            ),
          ];
        },
      ).then((_) {
        if (mounted) {
          context.read<GetPaymentsCubit>().getPayments();
        }
      });

  void _showPaymentActions(PRFPayment payment) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) => [
        WoltModalSheetPage(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.paymentActions,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  if (payment.authorizationUrl != null)
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                        ),
                        child: Icon(
                          Icons.open_in_browser_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(
                        l10n.completePayment,
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        l10n.openPaymentLink,
                        style: theme.textTheme.bodyMedium,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        final uri = Uri.parse(payment.authorizationUrl!);
                        await UrlHelper.openUrl(uri).then((_) {
                          // ignore: use_build_context_synchronously
                          context.read<GetPaymentsCubit>().getPayments();
                        });
                      },
                    ),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      l10n.refreshStatus,
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      l10n.checkPaymentStatus,
                      style: theme.textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<GetPaymentsCubit>().getPayments();
                    },
                  ),
                  const SizedBox(height: PRFSpacingTokens.xl),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentCard extends StatelessWidget with TimezoneMixin {
  const PaymentCard({required this.payment, super.key});

  final PRFPayment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Amount and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(payment.amount),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.md,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  payment.paymentStatus.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Date and Actions Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Expanded(
                    child: Text(
                      DateFormatter.formatDateTime(payment.createdAt, timezone),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (payment.authorizationUrl != null &&
                  (payment.paymentStatus != PRFPaymentStatus.success ||
                      payment.paymentStatus != PRFPaymentStatus.success)) ...[
                const SizedBox(height: PRFSpacingTokens.sm),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: Text(
                        l10n.longPressForActions,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final statusColors = context.statusColors;
    switch (payment.paymentStatus.name.toLowerCase()) {
      case 'success':
      case 'completed':
        return statusColors.completed.main;
      case 'pending':
        return statusColors.pending.main;
      case 'failed':
      case 'cancelled':
        return statusColors.failed.main;
      default:
        return context.colorScheme.primary;
    }
  }
}
