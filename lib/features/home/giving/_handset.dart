import 'package:app/enums/payment/prf_payment_status.dart';
import 'package:app/features/home/giving/actions/add_payment/add_payment.dart';
import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class GivingPageHandset extends StatefulWidget {
  const GivingPageHandset({super.key});

  @override
  State<GivingPageHandset> createState() => _GivingPageHandsetState();
}

class _GivingPageHandsetState extends State<GivingPageHandset> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentResourceCubit>().loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<PaymentResourceCubit, ResourceState<PRFPayment>>(
      builder: (context, state) {
        final payments = state.maybeWhen(
          listLoaded: (values, _, _) => values,
          orElse: List<PRFPayment>.empty,
        );
        final successfulCount = payments
            .where(
              (payment) => payment.paymentStatus == PRFPaymentStatus.success,
            )
            .length;
        final pendingCount = payments
            .where(
              (payment) =>
                  payment.paymentStatus == PRFPaymentStatus.pending ||
                  payment.paymentStatus == PRFPaymentStatus.initialised,
            )
            .length;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.88),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    PRFBrandedNavBar(
                      title: l10n.give,
                      onBack: () => context.router.popUntilRouteWithPath(
                        PRFSuperAppRouter.landingRoute,
                      ),
                      actions: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () =>
                                context.read<PaymentResourceCubit>().loadAll(),
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.xs,
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.lg,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.startGiving,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Wrap(
                              spacing: PRFSpacingTokens.xs,
                              runSpacing: PRFSpacingTokens.xs,
                              children: [
                                _GivingStatPill(
                                  label: l10n.total,
                                  value: payments.length,
                                ),
                                _GivingStatPill(
                                  label: PRFPaymentStatus.pending.name,
                                  value: pendingCount,
                                ),
                                _GivingStatPill(
                                  label: l10n.completed,
                                  value: successfulCount,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<PaymentResourceCubit>().loadAll(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          110,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          error: (message, _) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: PRFEmptyView(
                                label: l10n.considerGiving,
                                description: message,
                                icon: Icons.error_outline_rounded,
                              ),
                            ),
                          ),
                          listLoaded: (values, _, _) {
                            if (values.isEmpty) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.considerGiving,
                                    description: l10n.startGiving,
                                    icon: Icons.volunteer_activism_rounded,
                                    actionLabel: l10n.give,
                                    onActionPressed: _addPayment,
                                  ),
                                ),
                              );
                            }

                            return SliverList.builder(
                              itemCount: values.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: PRFSpacingTokens.md,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.recentPayments,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.78),
                                                ),
                                          ),
                                        ),
                                        Text(
                                          '${values.length}',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final paymentIndex = index - 1;
                                final payment = values[paymentIndex];
                                return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            paymentIndex == values.length - 1
                                            ? 0
                                            : PRFSpacingTokens.lg,
                                      ),
                                      child: Material(
                                        color: PRFColors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.xl,
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              _showPaymentActions(payment),
                                          borderRadius: BorderRadius.circular(
                                            PRFRadiusTokens.xl,
                                          ),
                                          splashColor: theme.colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          highlightColor: theme
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.05),
                                          child: PaymentCard(payment: payment),
                                        ),
                                      ),
                                    )
                                    .animate(
                                      delay: Duration(
                                        milliseconds: 70 * paymentIndex,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideY(
                                      begin: 0.22,
                                      end: 0,
                                      duration: PRFMotionTokens.enterMedium,
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.28),
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
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        l10n.give,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: PRFMotionTokens.enterMedium)
                    .slideY(begin: 0.2, end: 0),
          ),
        );
      },
    );
  }

  void _addPayment() =>
      PRFBottomSheet.show<void>(
        context,
        title: context.l10n.give,
        child: const AddPaymentView(),
      ).then((_) {
        if (mounted) {
          context.read<PaymentResourceCubit>().loadAll();
        }
      });

  void _showPaymentActions(PRFPayment payment) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    PRFBottomSheet.show<void>(
      context,
      title: l10n.paymentActions,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (payment.authorizationUrl != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      PRFRadiusTokens.smd,
                    ),
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
                    context.read<PaymentResourceCubit>().loadAll();
                  });
                },
              ),
            const SizedBox(height: PRFSpacingTokens.lg),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(
                    PRFRadiusTokens.smd,
                  ),
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
                context.read<PaymentResourceCubit>().loadAll();
              },
            ),
            const SizedBox(height: PRFSpacingTokens.xl),
          ],
        ),
      ),
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

    final formattedAmount = NumberFormat.currency(
      locale: 'en_KE',
      symbol: 'KES ',
    ).format(payment.amount);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  ),
                  child: Icon(
                    Icons.volunteer_activism_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Text(
                    formattedAmount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PRFStatusBadge(
                  label: payment.paymentStatus.name.toUpperCase(),
                  color: statusColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.md,
                    vertical: PRFSpacingTokens.xs,
                  ),
                  boxShadow: const [],
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                    color: PRFColors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.md),
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
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.north_east_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            if (payment.authorizationUrl != null &&
                payment.paymentStatus != PRFPaymentStatus.success) ...[
              const SizedBox(height: PRFSpacingTokens.sm),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: PRFSpacingTokens.xs),
                  Expanded(
                    child: Text(
                      l10n.tapForActions,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
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

class _GivingStatPill extends StatelessWidget {
  const _GivingStatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
