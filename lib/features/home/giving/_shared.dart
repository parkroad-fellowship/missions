import 'package:app/enums/payment/prf_payment_status.dart';
import 'package:app/features/home/giving/actions/add_payment/add_payment.dart';
import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class GivingFormState {
  GivingFormState();

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    context.read<PaymentResourceCubit>().loadAll();
  }

  void dispose() {}
}

class GivingStatPill extends StatelessWidget {
  const GivingStatPill({required this.label, required this.value, super.key});

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

Widget buildGivingHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  List<PRFPayment> payments,
  int pendingCount,
  int successfulCount,
  VoidCallback onBack,
  VoidCallback onRefresh,
) {
  return Container(
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
          onBack: onBack,
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
                onPressed: onRefresh,
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
                    GivingStatPill(
                      label: l10n.total,
                      value: payments.length,
                    ),
                    GivingStatPill(
                      label: PRFPaymentStatus.pending.name,
                      value: pendingCount,
                    ),
                    GivingStatPill(
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
  );
}

void triggerAddPayment(BuildContext context) {
  PRFBottomSheet.show<void>(
    context,
    title: context.l10n.give,
    child: const AddPaymentView(),
  ).then((_) {
    // Refresh parent cubit
    context.read<PaymentResourceCubit>().loadAll();
  });
}

void showPaymentActions(BuildContext context, PRFPayment payment) {
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
