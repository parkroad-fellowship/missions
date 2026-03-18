import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
            theme.colorScheme.secondary.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                    Icons.celebration_rounded,
                    size: 80,
                    color: PRFColors.white,
                  )
                  .animate()
                  .scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),
              const SizedBox(height: PRFSpacingTokens.xxl),
              Text(
                    memberName,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: PRFMotionTokens.slow)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.lg),
              Text(
                    'Your $year',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: PRFMotionTokens.enterShort)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                    'Missions Wrapped',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 900.ms)
                  .fadeIn(duration: 1000.ms)
                  .scale(curve: Curves.easeOut),
              const SizedBox(height: 48),
              Text(
                    'Swipe to see your journey',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 1500.ms)
                  .fadeIn()
                  .then(delay: PRFMotionTokens.enterShort)
                  .shimmer(duration: 2000.ms, color: PRFColors.white),
              const SizedBox(height: PRFSpacingTokens.lg),
              Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: PRFColors.white.withValues(alpha: 0.8),
                    size: 24,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .slideX(
                    begin: 0,
                    end: 0.3,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .slideX(
                    begin: 0.3,
                    end: 0,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'Your Mission Journey',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: missionStats.totalMissions.toString(),
                label: 'Total Missions',
                icon: Icons.explore_rounded,
                color: PRFColors.white,
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      value: missionStats.schoolsReached.toString(),
                      label: 'Schools Reached',
                      icon: Icons.school_rounded,
                      color: theme.colorScheme.secondary,
                      delay: PRFMotionTokens.slow,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.lg),
                  Expanded(
                    child: AnimatedStatCard(
                      value:
                          '${missionStats.completionRate.toStringAsFixed(0)}%',
                      label: 'Completion',
                      icon: Icons.check_circle_rounded,
                      color: theme.colorScheme.secondary,
                      delay: PRFMotionTokens.enterShort,
                    ),
                  ),
                ],
              ),
              if (missionStats.missionStreak > 0) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                StatHighlightCard(
                  title: '🔥 ${missionStats.missionStreak} Mission Streak!',
                  subtitle: 'Keep up the amazing work',
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: 800.ms,
                ),
              ],
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'Your Impact',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: impactStats.soulsTouched.toString(),
                label: 'Souls Touched',
                icon: Icons.favorite_rounded,
                color: PRFColors.white,
              ),
              if (impactStats.mostImpactfulMission != null) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                StatHighlightCard(
                  title: impactStats.mostImpactfulMission!.name,
                  subtitle:
                      'Your most impactful mission '
                      'with ${impactStats.mostImpactfulMission!.soulsCount} '
                      'souls',
                  icon: Icons.star_rounded,
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: PRFMotionTokens.slow,
                ),
              ],
              if (impactStats.decisionTypes.isNotEmpty) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                PRFDetailActionCard(
                      title: 'Decision Types',
                      subtitle: 'Top categories from your mission impact',
                      margin: EdgeInsets.zero,
                      backgroundColor: PRFColors.white.withValues(alpha: 0.15),
                      footer: Column(
                        children: [
                          ...impactStats.decisionTypes.take(3).map(
                                (decisionType) => Padding(
                                  padding: const EdgeInsets.only(
                                    top: PRFSpacingTokens.sm,
                                  ),
                                  child: PRFInfoCard(
                                    icon: Icons.label_rounded,
                                    label: decisionType.type,
                                    value: decisionType.count.toString(),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    )
                    .animate(delay: PRFMotionTokens.enterShort)
                    .fadeIn(duration: PRFMotionTokens.enterShort)
                    .slideY(begin: 0.3, end: 0),
              ],
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'Your Learning Growth',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      value: learningStats.coursesCompleted.toString(),
                      label: 'Courses\nCompleted',
                      icon: Icons.workspace_premium_rounded,
                      color: PRFColors.white,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.lg),
                  Expanded(
                    child: AnimatedStatCard(
                      value: learningStats.lessonsCompleted.toString(),
                      label: 'Lessons\nCompleted',
                      icon: Icons.book_rounded,
                      color: PRFColors.white,
                      delay: PRFMotionTokens.standard,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              AnimatedStatCard(
                value:
                    // ignore: lines_longer_than_80_chars
                    '${learningStats.learningProgressPercentage.toStringAsFixed(0)}%',
                label: 'Overall Progress',
                icon: Icons.trending_up_rounded,
                color: theme.colorScheme.secondary,
                delay: PRFMotionTokens.slow,
              ),
              if (learningStats.learningStreak > 0) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                StatHighlightCard(
                  title: '📚 ${learningStats.learningStreak} Day Streak!',
                  subtitle: "You're on fire! Keep learning",
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: PRFMotionTokens.enterShort,
                ),
              ],
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'Your Prayer Journey',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: prayerStats.prayerResponses.toString(),
                label: 'Prayer Responses',
                icon: Icons.volunteer_activism_rounded,
                color: PRFColors.white,
              ),
              if (prayerStats.prayerConsistencyDays > 0) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                StatHighlightCard(
                  title:
                      '🙏 ${prayerStats.prayerConsistencyDays} Days of Prayer',
                  subtitle: 'Your faith journey continues',
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: PRFMotionTokens.slow,
                ),
              ],
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'Your Event Participation',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      value: eventStats.eventsAttended.toString(),
                      label: 'Events\nAttended',
                      icon: Icons.event_rounded,
                      color: PRFColors.white,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.lg),
                  Expanded(
                    child: AnimatedStatCard(
                      value: eventStats.upcomingEvents.toString(),
                      label: 'Upcoming\nEvents',
                      icon: Icons.event_available_rounded,
                      color: theme.colorScheme.secondary,
                      delay: PRFMotionTokens.standard,
                    ),
                  ),
                ],
              ),
              if (eventStats.eventsAttended > 0) ...[
                const SizedBox(height: PRFSpacingTokens.xl),
                StatHighlightCard(
                  title: '🎉 Active Participant!',
                  subtitle: 'Thank you for being part of our community',
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: PRFMotionTokens.slow,
                ),
              ],
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
            theme.colorScheme.secondary.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    'What a Year!',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .scale(curve: Curves.easeOut),
              const SizedBox(height: 48),
              PRFDetailActionCard(
                    title: '$year Highlights',
                    subtitle: 'A snapshot of your impact this year',
                    margin: EdgeInsets.zero,
                    backgroundColor: PRFColors.white.withValues(alpha: 0.15),
                    footer: Column(
                      children: [
                        PRFInfoCard(
                          icon: Icons.explore_rounded,
                          label: 'Missions',
                          value:
                              memberEngagement.missionStats.totalMissions
                                  .toString(),
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        PRFInfoCard(
                          icon: Icons.favorite_rounded,
                          label: 'Souls Touched',
                          value:
                              memberEngagement.impactStats.soulsTouched
                                  .toString(),
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        PRFInfoCard(
                          icon: Icons.workspace_premium_rounded,
                          label: 'Courses',
                          value:
                              memberEngagement
                                  .learningStats
                                  .coursesCompleted
                                  .toString(),
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        PRFInfoCard(
                          icon: Icons.event_rounded,
                          label: 'Events',
                          value:
                              memberEngagement.eventStats.eventsAttended
                                  .toString(),
                        ),
                      ],
                    ),
                  )
                  .animate(delay: PRFMotionTokens.slow)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 48),
              Text(
                    'Thank you for making\nan impact in $year!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 1000.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),
              Text(
                    "Let's make next year even better! 🚀",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 800.ms)
                  .then(delay: PRFMotionTokens.enterShort)
                  .shimmer(duration: 2000.ms, color: PRFColors.white),
            ],
          ),
        ),
      ),
    );
  }

}
