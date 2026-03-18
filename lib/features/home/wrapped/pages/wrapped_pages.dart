import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:prf_design/prf_design.dart';

class IntroWrappedPage extends StatelessWidget {
  const IntroWrappedPage({
    required this.memberName,
    required this.year,
    super.key,
  });

  final String memberName;
  final int year;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF0B072B),
        Color(0xFF17154C),
        Color(0xFF2738AA),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_intro_pulse.json',
          height: 140,
          delay: Duration(milliseconds: 80),
        ),
        const SizedBox(height: PRFSpacingTokens.xl),
        Text(
              memberName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: PRFColors.white,
                fontWeight: FontWeight.w900,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.25, end: 0, duration: 500.ms),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
              l10n.wrappedYourYear(year),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PRFColors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
            )
            .animate(delay: 180.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.25, end: 0, duration: 500.ms),
        const SizedBox(height: PRFSpacingTokens.sm),
        Text(
          l10n.wrappedTagline,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: PRFColors.white,
            fontWeight: FontWeight.w900,
            fontSize: 48,
            height: 0.98,
          ),
        ).animate(delay: 320.ms).fadeIn(duration: 600.ms).scale(),
        const SizedBox(height: PRFSpacingTokens.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swipe_rounded,
              color: PRFColors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: PRFSpacingTokens.xs),
            Text(
              l10n.wrappedSwipeHint,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: PRFColors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ).animate(delay: 650.ms).fadeIn(duration: 500.ms),
      ],
    );
  }
}

class MissionsWrappedPage extends StatelessWidget {
  const MissionsWrappedPage({
    required this.missionStats,
    super.key,
  });

  final MissionStats missionStats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF0A1A42),
        Color(0xFF142B6F),
        Color(0xFF2D5EFF),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_missions_beam.json',
          height: 112,
          delay: Duration(milliseconds: 70),
        ),
        WrappedSectionTitle(
          title: l10n.wrappedMissionsTitle,
          delay: const Duration(milliseconds: 120),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        AnimatedStatCard(
          value: missionStats.totalMissions.toString(),
          label: l10n.wrappedTotalMissions,
          icon: Icons.explore_rounded,
          color: PRFColors.white,
          semanticLabel:
              '${l10n.wrappedTotalMissions}: ${missionStats.totalMissions}',
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Row(
          children: [
            Expanded(
              child: AnimatedStatCard(
                value: missionStats.schoolsReached.toString(),
                label: l10n.wrappedSchoolsReached,
                icon: Icons.school_rounded,
                color: const Color(0xFF93D500),
                delay: 220.ms,
                semanticLabel:
                    '${l10n.wrappedSchoolsReached}: ${missionStats.schoolsReached}',
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: AnimatedStatCard(
                value: '${missionStats.completionRate.toStringAsFixed(0)}%',
                label: l10n.wrappedCompletion,
                icon: Icons.check_circle_rounded,
                color: const Color(0xFF93D500),
                delay: 300.ms,
                semanticLabel:
                    '${l10n.wrappedCompletion}: ${missionStats.completionRate.toStringAsFixed(0)}%',
              ),
            ),
          ],
        ),
        if (missionStats.missionStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: l10n.wrappedMissionStreakTitle(missionStats.missionStreak),
            subtitle: l10n.wrappedMissionStreakSubtitle,
            gradient: const [Color(0xFF8EFF00), Color(0xFF3A8A00)],
            icon: Icons.local_fire_department_rounded,
            delay: 420.ms,
          ),
        ],
      ],
    );
  }
}

class ImpactWrappedPage extends StatelessWidget {
  const ImpactWrappedPage({
    required this.impactStats,
    super.key,
  });

  final ImpactStats impactStats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF230F50),
        Color(0xFF351A7A),
        Color(0xFF5A24B0),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_impact_orbit.json',
          height: 112,
          delay: Duration(milliseconds: 70),
        ),
        WrappedSectionTitle(
          title: l10n.wrappedImpactTitle,
          delay: const Duration(milliseconds: 120),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        AnimatedStatCard(
          value: impactStats.soulsTouched.toString(),
          label: l10n.wrappedSoulsTouched,
          icon: Icons.favorite_rounded,
          color: PRFColors.white,
          semanticLabel:
              '${l10n.wrappedSoulsTouched}: ${impactStats.soulsTouched}',
        ),
        if (impactStats.mostImpactfulMission != null) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: impactStats.mostImpactfulMission!.name,
            subtitle: l10n.wrappedMostImpactfulMissionSubtitle(
              impactStats.mostImpactfulMission!.soulsCount,
            ),
            icon: Icons.auto_awesome_rounded,
            gradient: const [Color(0xFFFF8A00), Color(0xFFFF3D00)],
            delay: 300.ms,
          ),
        ],
        if (impactStats.decisionTypes.isNotEmpty) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: l10n.wrappedDecisionTypes,
            subtitle: l10n.wrappedDecisionTypesSubtitle,
            icon: Icons.style_rounded,
            gradient: const [Color(0xFF2C6BFF), Color(0xFF1A2A7A)],
            delay: 420.ms,
            child: Column(
              children: [
                ...impactStats.decisionTypes
                    .take(3)
                    .map(
                      (decisionType) => Padding(
                        padding: const EdgeInsets.only(
                          top: PRFSpacingTokens.sm,
                        ),
                        child: _WrappedMiniInfoRow(
                          label: decisionType.type,
                          value: decisionType.count.toString(),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class LearningWrappedPage extends StatelessWidget {
  const LearningWrappedPage({
    required this.learningStats,
    super.key,
  });

  final LearningStats learningStats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF003D3D),
        Color(0xFF005D5D),
        Color(0xFF008080),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_learning_wave.json',
          height: 108,
          delay: Duration(milliseconds: 80),
        ),
        WrappedSectionTitle(
          title: l10n.wrappedLearningTitle,
          delay: const Duration(milliseconds: 130),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Row(
          children: [
            Expanded(
              child: AnimatedStatCard(
                value: learningStats.coursesCompleted.toString(),
                label: l10n.wrappedCoursesCompleted,
                icon: Icons.workspace_premium_rounded,
                color: PRFColors.white,
                semanticLabel:
                    '${l10n.wrappedCoursesCompleted}: ${learningStats.coursesCompleted}',
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: AnimatedStatCard(
                value: learningStats.lessonsCompleted.toString(),
                label: l10n.wrappedLessonsCompleted,
                icon: Icons.menu_book_rounded,
                color: PRFColors.white,
                delay: 230.ms,
                semanticLabel:
                    '${l10n.wrappedLessonsCompleted}: ${learningStats.lessonsCompleted}',
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        AnimatedStatCard(
          value:
              '${learningStats.learningProgressPercentage.toStringAsFixed(0)}%',
          label: l10n.wrappedOverallProgress,
          icon: Icons.trending_up_rounded,
          color: const Color(0xFF93D500),
          delay: 320.ms,
          semanticLabel:
              '${l10n.wrappedOverallProgress}: ${learningStats.learningProgressPercentage.toStringAsFixed(0)}%',
        ),
        if (learningStats.learningStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: l10n.wrappedLearningStreakTitle(
              learningStats.learningStreak,
            ),
            subtitle: l10n.wrappedLearningStreakSubtitle,
            gradient: const [Color(0xFFFFD400), Color(0xFFFF8A00)],
            icon: Icons.flash_on_rounded,
            delay: 450.ms,
          ),
        ],
      ],
    );
  }
}

class PrayerWrappedPage extends StatelessWidget {
  const PrayerWrappedPage({
    required this.prayerStats,
    super.key,
  });

  final PrayerStats prayerStats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF1A103D),
        Color(0xFF32206C),
        Color(0xFF5530A8),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_prayer_glow.json',
          height: 108,
          delay: Duration(milliseconds: 80),
        ),
        WrappedSectionTitle(
          title: l10n.wrappedPrayerTitle,
          delay: const Duration(milliseconds: 130),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        AnimatedStatCard(
          value: prayerStats.prayerResponses.toString(),
          label: l10n.wrappedPrayerResponses,
          icon: Icons.volunteer_activism_rounded,
          color: PRFColors.white,
          semanticLabel:
              '${l10n.wrappedPrayerResponses}: ${prayerStats.prayerResponses}',
        ),
        if (prayerStats.prayerConsistencyDays > 0) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: l10n.wrappedPrayerConsistencyTitle(
              prayerStats.prayerConsistencyDays,
            ),
            subtitle: l10n.wrappedPrayerConsistencySubtitle,
            gradient: const [Color(0xFF90CAF9), Color(0xFF1976D2)],
            icon: Icons.bolt_rounded,
            delay: 360.ms,
          ),
        ],
      ],
    );
  }
}

class EventsWrappedPage extends StatelessWidget {
  const EventsWrappedPage({
    required this.eventStats,
    super.key,
  });

  final EventStats eventStats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF1C1A32),
        Color(0xFF3A2F66),
        Color(0xFF5F46A3),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_events_rhythm.json',
          height: 110,
          delay: Duration(milliseconds: 85),
        ),
        WrappedSectionTitle(
          title: l10n.wrappedEventsTitle,
          delay: const Duration(milliseconds: 140),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Row(
          children: [
            Expanded(
              child: AnimatedStatCard(
                value: eventStats.eventsAttended.toString(),
                label: l10n.wrappedEventsAttended,
                icon: Icons.event_rounded,
                color: PRFColors.white,
                semanticLabel:
                    '${l10n.wrappedEventsAttended}: ${eventStats.eventsAttended}',
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: AnimatedStatCard(
                value: eventStats.upcomingEvents.toString(),
                label: l10n.wrappedUpcomingEvents,
                icon: Icons.event_available_rounded,
                color: const Color(0xFF93D500),
                delay: 230.ms,
                semanticLabel:
                    '${l10n.wrappedUpcomingEvents}: ${eventStats.upcomingEvents}',
              ),
            ),
          ],
        ),
        if (eventStats.eventsAttended > 0) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          StatHighlightCard(
            title: l10n.wrappedActiveParticipantTitle,
            subtitle: l10n.wrappedActiveParticipantSubtitle,
            gradient: const [Color(0xFF00E5FF), Color(0xFF0066FF)],
            icon: Icons.celebration_rounded,
            delay: 420.ms,
          ),
        ],
      ],
    );
  }
}

class SummaryWrappedPage extends StatelessWidget {
  const SummaryWrappedPage({
    required this.memberEngagement,
    required this.year,
    super.key,
  });

  final PRFMemberEngagement memberEngagement;
  final int year;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WrappedStoryPage(
      gradientStops: const [
        Color(0xFF10112A),
        Color(0xFF253063),
        Color(0xFF324FBC),
      ],
      children: [
        const _LottiePulse(
          assetPath: 'assets/images/wrapped_finale_pulse.json',
          height: 134,
          delay: Duration(milliseconds: 120),
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        WrappedSectionTitle(
          title: l10n.wrappedSummaryTitle,
          delay: const Duration(milliseconds: 180),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        StatHighlightCard(
          title: l10n.wrappedHighlightsTitle(year),
          subtitle: l10n.wrappedHighlightsSubtitle,
          icon: Icons.insights_rounded,
          gradient: const [Color(0xFF5A78FF), Color(0xFF243D9E)],
          child: Column(
            children: [
              _WrappedMiniInfoRow(
                label: l10n.wrappedMissionsLabel,
                value: memberEngagement.missionStats.totalMissions.toString(),
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              _WrappedMiniInfoRow(
                label: l10n.wrappedSoulsTouched,
                value: memberEngagement.impactStats.soulsTouched.toString(),
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              _WrappedMiniInfoRow(
                label: l10n.wrappedCoursesLabel,
                value: memberEngagement.learningStats.coursesCompleted
                    .toString(),
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              _WrappedMiniInfoRow(
                label: l10n.wrappedEventsLabel,
                value: memberEngagement.eventStats.eventsAttended.toString(),
              ),
            ],
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.xl),
        Text(
          l10n.wrappedThankYouSubtitle(year),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: PRFColors.white,
            fontWeight: FontWeight.w700,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 450.ms),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
              l10n.wrappedNextYearCta,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: PRFColors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            )
            .animate(delay: 380.ms)
            .fadeIn(duration: 500.ms)
            .then(delay: 180.ms)
            .shimmer(duration: 1300.ms, color: PRFColors.white),
      ],
    );
  }
}

class WrappedStoryPage extends StatelessWidget {
  const WrappedStoryPage({
    required this.gradientStops,
    required this.children,
    super.key,
  });

  final List<Color> gradientStops;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final disableMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final content = ListView(
      padding: const EdgeInsets.fromLTRB(
        PRFSpacingTokens.xl,
        PRFSpacingTokens.xxl,
        PRFSpacingTokens.xl,
        PRFSpacingTokens.xl,
      ),
      children: children,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientStops,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -80,
              child: _GlowOrb(
                color: PRFColors.white.withValues(alpha: 0.16),
                size: 240,
              ),
            ),
            Positioned(
              bottom: -130,
              left: -70,
              child: _GlowOrb(
                color: const Color(0xFF93D500).withValues(alpha: 0.2),
                size: 260,
              ),
            ),
            if (disableMotion)
              content
            else
              content.animate().fadeIn(duration: 350.ms),
          ],
        ),
      ),
    );
  }
}

class WrappedSectionTitle extends StatelessWidget {
  const WrappedSectionTitle({
    required this.title,
    this.delay = Duration.zero,
    super.key,
  });

  final String title;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        color: PRFColors.white,
        fontWeight: FontWeight.w900,
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 420.ms)
        .slideY(begin: -0.18, end: 0, duration: 420.ms);
  }
}

class AnimatedStatCard extends StatelessWidget {
  const AnimatedStatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.delay = Duration.zero,
    this.semanticLabel,
    super.key,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Duration delay;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: PRFColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        border: Border.all(
          color: PRFColors.white.withValues(alpha: 0.24),
        ),
      ),
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            decoration: BoxDecoration(
              color: PRFColors.black.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: PRFSpacingTokens.md),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: PRFColors.white,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PRFColors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: semanticLabel,
      child: card
          .animate(delay: delay)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }
}

class StatHighlightCard extends StatelessWidget {
  const StatHighlightCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.icon,
    this.delay = Duration.zero,
    this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData? icon;
  final Duration delay;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
            border: Border.all(
              color: PRFColors.white.withValues(alpha: 0.18),
            ),
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: PRFColors.white),
                    const SizedBox(width: PRFSpacingTokens.xs),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PRFColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PRFColors.white.withValues(alpha: 0.9),
                ),
              ),
              if (child != null) ...[
                const SizedBox(height: PRFSpacingTokens.sm),
                child!,
              ],
            ],
          ),
        )
        .animate(delay: delay)
        .fadeIn(duration: 420.ms)
        .slideY(begin: 0.2, end: 0, duration: 420.ms);
  }
}

class WrappedStoryPageIndicator extends StatelessWidget {
  const WrappedStoryPageIndicator({
    required this.currentPage,
    required this.pageCount,
    super.key,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Semantics(
      label: l10n.wrappedProgressSemantics(currentPage + 1, pageCount),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl),
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.md,
          vertical: PRFSpacingTokens.sm,
        ),
        decoration: BoxDecoration(
          color: PRFColors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          border: Border.all(
            color: PRFColors.white.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pageCount, (index) {
            final isCurrent = currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              width: isCurrent ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isCurrent
                    ? const Color(0xFF93D500)
                    : PRFColors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _WrappedMiniInfoRow extends StatelessWidget {
  const _WrappedMiniInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: PRFColors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PRFColors.white.withValues(alpha: 0.88),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: PRFColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _LottiePulse extends StatelessWidget {
  const _LottiePulse({
    required this.assetPath,
    this.height = 120,
    this.delay = Duration.zero,
  });

  final String assetPath;
  final double height;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final disableMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableMotion) {
      return const SizedBox.shrink();
    }

    return SizedBox(
          height: height,
          child: Lottie.asset(
            assetPath,
            repeat: true,
            animate: true,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        )
        .animate(delay: delay)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.82, 0.82), end: const Offset(1, 1));
  }
}
