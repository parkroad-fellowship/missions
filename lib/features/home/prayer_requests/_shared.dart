import 'package:app/features/home/prayer_requests/actions/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class PrayerRequestsFormState {
  PrayerRequestsFormState();

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    context.read<PrayerRequestResourceCubit>().loadAll();
  }

  void dispose() {}
}

class PrayerStatPill extends StatelessWidget {
  const PrayerStatPill({required this.label, required this.value, super.key});

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

Widget buildPrayerHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  List<PRFPrayerRequest> prayerRequests,
  int activeCount,
  VoidCallback onBack,
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
          title: l10n.prayerRequests,
          onBack: onBack,
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
                  l10n.submitPrayerRequestDesc,
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
                    PrayerStatPill(
                      label: l10n.total,
                      value: prayerRequests.length,
                    ),
                    PrayerStatPill(
                      label: l10n.activeNow,
                      value: activeCount,
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

void triggerAddPrayerRequest(BuildContext context) {
  PRFBottomSheet.show<void>(
    context,
    title: context.l10n.submitPrayerRequest,
    child: const AddPrayerRequestView(),
  ).then((_) {
    // Refresh parent cubit
    context.read<PrayerRequestResourceCubit>().loadAll();
  });
}
