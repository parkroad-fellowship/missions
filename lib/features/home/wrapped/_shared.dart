import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class TimelineProgressBar extends AnimatedWidget {
  const TimelineProgressBar({
    required super.listenable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (listenable as Animation<double>).value;
    return SizedBox(
      width: double.infinity,
      height: 2,
      child: Stack(
        children: [
          Container(color: PRFColors.white.withValues(alpha: 0.15)),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(color: PRFColors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class WrappedPageEntry {
  const WrappedPageEntry({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}

Widget buildWrappedLoadingState(ThemeData theme) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: const Center(
        child: PRFCircularProgressIndicator(),
      ),
    ),
  );
}

Widget buildWrappedEmptyState(BuildContext context, AppLocalizations l10n) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: PRFEmptyView(
              label: l10n.wrappedNoImpactDataTitle,
              description: l10n.wrappedNoImpactDataDescription,
              icon: Icons.insights_rounded,
              actionLabel: l10n.wrappedGoBack,
              onActionPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildWrappedErrorState(
  BuildContext context,
  AppLocalizations l10n,
  String message,
) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: PRFEmptyView(
              label: l10n.wrappedSomethingWentWrong,
              description: message,
              icon: Icons.error_outline_rounded,
              actionLabel: l10n.wrappedTryAgain,
              onActionPressed: () {
                context.read<MemberEngagementResourceCubit>().loadEngagement(
                  year: DateTime.now().year,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildInsufficientDataPage(BuildContext context, AppLocalizations l10n) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: PRFColors.white),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: CinematicSlide(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: PRFColors.white.withValues(alpha: 0.5),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Text(
                  'Not enough data yet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: PRFColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                Text(
                  'Complete missions, courses, and more\nto unlock your Wrapped next season!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: PRFColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
