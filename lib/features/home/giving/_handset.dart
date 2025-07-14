import 'package:app/features/home/giving/actions/add_payment/add_payment.dart';
import 'package:app/features/home/giving/cubit/get_payments_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_payment.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:app/shared_widgets/navbar/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GivingPageHandset extends StatefulWidget {
  const GivingPageHandset({super.key});

  @override
  State<GivingPageHandset> createState() => _GivingPageHandsetState();
}

class _GivingPageHandsetState extends State<GivingPageHandset> {
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
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

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
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                message,
                                style: theme.textTheme.bodyLarge,
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
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          child: PRFEmptyView(
                            label: l10n.considerGiving,
                            description: 'Start your giving journey today',
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
                      left: 16,
                      right: 16,
                      bottom: 100, // Space for FAB
                    ),
                    sliver: SliverList.separated(
                      itemCount: payments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                                child: InkWell(
                                  onLongPress: () =>
                                      _showPaymentActions(payment),
                                  borderRadius: BorderRadius.circular(24),
                                  splashColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  highlightColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.05),
                                  child: PaymentCard(payment: payment),
                                ),
                              ),
                            )
                            .animate(delay: Duration(milliseconds: index * 100))
                            .fadeIn(duration: const Duration(milliseconds: 600))
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                            )
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                            );
                      },
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            FloatingActionButton.extended(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              onPressed: _addPayment,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                l10n.give,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ).animate(
              effects: [
                const ShimmerEffect(
                  duration: Duration(seconds: 2),
                  delay: Duration(milliseconds: 500),
                ),
                const ScaleEffect(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1, 1),
                  duration: Duration(milliseconds: 400),
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
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.paymentActions,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  if (payment.authorizationUrl != null)
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
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
                        await Misc.openUrl(uri);
                      },
                    ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 24),
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
    final statusColor = _getStatusColor(theme);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  NumberFormat.currency(
                    locale: 'en_KE',
                    symbol: 'KES ',
                  ).format(payment.amount),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                Misc.formatDateTime(payment.createdAt, timezone),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (payment.authorizationUrl != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Long press for payment actions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (payment.paymentStatus.name.toLowerCase()) {
      case 'success':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }
}
