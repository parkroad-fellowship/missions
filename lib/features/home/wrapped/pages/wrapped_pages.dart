import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:prf_design/prf_design.dart';
import 'package:share_plus/share_plus.dart';

// =============================================================================
// CINEMATIC SHARED WIDGETS
// =============================================================================

class _FullScreenLottie extends StatelessWidget {
  const _FullScreenLottie({
    required this.assetPath,
    this.opacity = 0.35,
  });

  final String assetPath;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Lottie.asset(
          assetPath,
          fit: BoxFit.cover,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}

class CinematicSlide extends StatelessWidget {
  const CinematicSlide({
    required this.children,
    super.key,
    this.lottieAsset,
    this.lottieOpacity = 0.35,
  });

  final String? lottieAsset;
  final double lottieOpacity;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0A0A0F),
      child: Stack(
        children: [
          if (lottieAsset != null)
            _FullScreenLottie(
              assetPath: lottieAsset!,
              opacity: lottieOpacity,
            ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroNumber extends StatelessWidget {
  const HeroNumber({
    required this.value,
    this.label,
    this.numberSize = 72,
    this.labelSize = 16,
    super.key,
  });

  final int value;
  final String? label;
  final double numberSize;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 1800),
              builder: (context, count, _) {
                return Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: numberSize,
                    fontWeight: FontWeight.w800,
                    color: PRFColors.white,
                    height: 1,
                  ),
                );
              },
            )
            .animate(delay: 300.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),
        if (label != null) ...[
          const SizedBox(height: PRFSpacingTokens.sm),
          Text(
                label!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: labelSize,
                  fontWeight: FontWeight.w500,
                  color: PRFColors.white.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ],
    );
  }
}

// =============================================================================
// UTILITY WIDGETS
// =============================================================================

class _EmptySectionContent extends StatelessWidget {
  const _EmptySectionContent({
    required this.message,
    required this.icon,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 48, color: PRFColors.white.withValues(alpha: 0.3)),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: PRFColors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: PRFColors.white,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PAGE WIDGETS
// =============================================================================

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
    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_intro_pulse.json',
      lottieOpacity: 0.4,
      children: [
        Text(
          'Your $year',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: PRFColors.white.withValues(alpha: 0.5),
            letterSpacing: 2,
          ),
        ).animate(delay: 600.ms).fadeIn(duration: 500.ms),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
              memberName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: PRFColors.white,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            )
            .animate(delay: 800.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 10, end: 0),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          'Missions Wrapped',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: PRFColors.white.withValues(alpha: 0.4),
            letterSpacing: 3,
          ),
        ).animate(delay: 1200.ms).fadeIn(duration: 500.ms),
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
    if (missionStats.totalMissions == 0) {
      return const CinematicSlide(
        lottieAsset: 'assets/images/wrapped_missions_beam.json',
        lottieOpacity: 0.25,
        children: [
          _EmptySectionContent(
            message: 'No missions yet.\nStart your first mission!',
            icon: Icons.explore_outlined,
          ),
        ],
      );
    }

    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_missions_beam.json',
      children: [
        HeroNumber(
          value: missionStats.totalMissions,
          label: 'missions completed',
          numberSize: 88,
        ),
        if (missionStats.missionStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: PRFColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
              border: Border.all(
                color: PRFColors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: Color(0xFFFF8A00),
                ),
                const SizedBox(width: 6),
                Text(
                  '${missionStats.missionStreak} mission streak',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFColors.white,
                  ),
                ),
              ],
            ),
          ).animate(delay: 800.ms).fadeIn().slideY(begin: 10, end: 0),
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
    if (impactStats.soulsTouched == 0) {
      return const CinematicSlide(
        lottieAsset: 'assets/images/wrapped_impact_orbit.json',
        lottieOpacity: 0.25,
        children: [
          _EmptySectionContent(
            message: 'No impact recorded yet.\nEvery mission touches lives!',
            icon: Icons.favorite_rounded,
          ),
        ],
      );
    }

    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_impact_orbit.json',
      children: [
        HeroNumber(
          value: impactStats.soulsTouched,
          label: 'souls touched',
          numberSize: 88,
        ),
        if (impactStats.mostImpactfulMission != null) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          Text(
            'through ${impactStats.mostImpactfulMission!.name}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: 0.6),
            ),
          ).animate(delay: 700.ms).fadeIn(),
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
    if (learningStats.coursesCompleted == 0 &&
        learningStats.lessonsCompleted == 0) {
      return const CinematicSlide(
        lottieAsset: 'assets/images/wrapped_learning_wave.json',
        lottieOpacity: 0.25,
        children: [
          _EmptySectionContent(
            message: 'No learning yet.\nStart a course to unlock this!',
            icon: Icons.menu_book_rounded,
          ),
        ],
      );
    }

    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_learning_wave.json',
      children: [
        HeroNumber(
          value: learningStats.coursesCompleted,
          label: 'courses completed',
          numberSize: 88,
        ),
        if (learningStats.learningStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: PRFColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
              border: Border.all(
                color: PRFColors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flash_on_rounded,
                  size: 16,
                  color: Color(0xFFFFD400),
                ),
                const SizedBox(width: 6),
                Text(
                  '${learningStats.learningStreak} day streak',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFColors.white,
                  ),
                ),
              ],
            ),
          ).animate(delay: 800.ms).fadeIn().slideY(begin: 10, end: 0),
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
    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_prayer_glow.json',
      children: [
        HeroNumber(
          value: prayerStats.prayerResponses,
          label: 'prayer responses',
          numberSize: 88,
        ),
        if (prayerStats.prayerConsistencyDays > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: PRFColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
              border: Border.all(
                color: PRFColors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: Color(0xFFB388FF),
                ),
                const SizedBox(width: 6),
                Text(
                  '${prayerStats.prayerConsistencyDays} days of prayer',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFColors.white,
                  ),
                ),
              ],
            ),
          ).animate(delay: 800.ms).fadeIn().slideY(begin: 10, end: 0),
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
    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_events_rhythm.json',
      children: [
        HeroNumber(
          value: eventStats.eventsAttended,
          label: 'events attended',
          numberSize: 88,
        ),
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

  String _shareText() {
    final m = memberEngagement;
    return 'My $year PRF Missions Wrapped:\n'
        '${m.missionStats.totalMissions} Missions\n'
        '${m.impactStats.soulsTouched} Souls Touched\n'
        '${m.learningStats.coursesCompleted} Courses\n'
        '${m.eventStats.eventsAttended} Events Attended\n'
        '${m.prayerStats.prayerResponses} Prayer Responses\n\n'
        'How was your year?';
  }

  @override
  Widget build(BuildContext context) {
    final m = memberEngagement;

    return CinematicSlide(
      lottieAsset: 'assets/images/wrapped_finale_pulse.json',
      children: [
        const Text(
          'What a Year!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: PRFColors.white,
          ),
        ).animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: PRFSpacingTokens.xl),
        _StatLine(
          value: m.missionStats.totalMissions.toString(),
          label: 'missions completed',
        ).animate(delay: 350.ms).fadeIn().slideY(begin: 10, end: 0),
        _StatLine(
          value: m.impactStats.soulsTouched.toString(),
          label: 'souls touched',
        ).animate(delay: 450.ms).fadeIn().slideY(begin: 10, end: 0),
        _StatLine(
          value: m.learningStats.coursesCompleted.toString(),
          label: 'courses completed',
        ).animate(delay: 550.ms).fadeIn().slideY(begin: 10, end: 0),
        if (m.prayerStats.prayerResponses > 0)
          _StatLine(
            value: m.prayerStats.prayerResponses.toString(),
            label: 'prayer responses',
          ).animate(delay: 650.ms).fadeIn().slideY(begin: 10, end: 0),
        if (m.eventStats.eventsAttended > 0)
          _StatLine(
            value: m.eventStats.eventsAttended.toString(),
            label: 'events attended',
          ).animate(delay: 750.ms).fadeIn().slideY(begin: 10, end: 0),
        const SizedBox(height: PRFSpacingTokens.xl),
        SizedBox(
          width: 200,
          child: OutlinedButton.icon(
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: _shareText(),
              ),
            ),
            icon: const Icon(Icons.share_rounded, color: PRFColors.white),
            label: const Text(
              'Share Your Wrapped',
              style: TextStyle(
                color: PRFColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: PRFColors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ).animate(delay: 900.ms).fadeIn().slideY(begin: 10, end: 0),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          'Thank you for making an impact\nin $year!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PRFColors.white.withValues(alpha: 0.6),
            height: 1.4,
          ),
        ).animate(delay: 1100.ms).fadeIn(),
      ],
    );
  }
}
