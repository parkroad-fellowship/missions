import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
          padding: const EdgeInsets.all(32),
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
              const SizedBox(height: 32),
              Text(
                    memberName,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 16),
              Text(
                    'Your $year',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
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
                  .then(delay: 500.ms)
                  .shimmer(duration: 2000.ms, color: PRFColors.white),
              const SizedBox(height: 16),
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: missionStats.totalMissions.toString(),
                label: 'Total Missions',
                icon: Icons.explore_rounded,
                color: PRFColors.white,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AnimatedStatCard(
                      value: missionStats.schoolsReached.toString(),
                      label: 'Schools Reached',
                      icon: Icons.school_rounded,
                      color: theme.colorScheme.secondary,
                      delay: 400.ms,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedStatCard(
                      value:
                          '${missionStats.completionRate.toStringAsFixed(0)}%',
                      label: 'Completion',
                      icon: Icons.check_circle_rounded,
                      color: theme.colorScheme.secondary,
                      delay: 600.ms,
                    ),
                  ),
                ],
              ),
              if (missionStats.missionStreak > 0) ...[
                const SizedBox(height: 24),
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: impactStats.soulsTouched.toString(),
                label: 'Souls Touched',
                icon: Icons.favorite_rounded,
                color: PRFColors.white,
              ),
              if (impactStats.mostImpactfulMission != null) ...[
                const SizedBox(height: 24),
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
                  delay: 400.ms,
                ),
              ],
              if (impactStats.decisionTypes.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: PRFColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: PRFColors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Decision Types',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: PRFColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...impactStats.decisionTypes
                              .take(3)
                              .map(
                                (dt) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dt.type,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: PRFColors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                      ),
                                      Text(
                                        dt.count.toString(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: PRFColors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 600.ms)
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedStatCard(
                      value: learningStats.lessonsCompleted.toString(),
                      label: 'Lessons\nCompleted',
                      icon: Icons.book_rounded,
                      color: PRFColors.white,
                      delay: 200.ms,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedStatCard(
                value:
                    // ignore: lines_longer_than_80_chars
                    '${learningStats.learningProgressPercentage.toStringAsFixed(0)}%',
                label: 'Overall Progress',
                icon: Icons.trending_up_rounded,
                color: theme.colorScheme.secondary,
                delay: 400.ms,
              ),
              if (learningStats.learningStreak > 0) ...[
                const SizedBox(height: 24),
                StatHighlightCard(
                  title: '📚 ${learningStats.learningStreak} Day Streak!',
                  subtitle: "You're on fire! Keep learning",
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: 600.ms,
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),
              const SizedBox(height: 48),
              AnimatedStatCard(
                value: prayerStats.prayerResponses.toString(),
                label: 'Prayer Responses',
                icon: Icons.volunteer_activism_rounded,
                color: PRFColors.white,
              ),
              if (prayerStats.prayerConsistencyDays > 0) ...[
                const SizedBox(height: 24),
                StatHighlightCard(
                  title:
                      '🙏 ${prayerStats.prayerConsistencyDays} Days of Prayer',
                  subtitle: 'Your faith journey continues',
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: 400.ms,
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedStatCard(
                      value: eventStats.upcomingEvents.toString(),
                      label: 'Upcoming\nEvents',
                      icon: Icons.event_available_rounded,
                      color: theme.colorScheme.secondary,
                      delay: 200.ms,
                    ),
                  ),
                ],
              ),
              if (eventStats.eventsAttended > 0) ...[
                const SizedBox(height: 24),
                StatHighlightCard(
                  title: '🎉 Active Participant!',
                  subtitle: 'Thank you for being part of our community',
                  gradient: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                  delay: 400.ms,
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
          padding: const EdgeInsets.all(24),
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
              ).animate().fadeIn(duration: 600.ms).scale(curve: Curves.easeOut),
              const SizedBox(height: 48),
              Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: PRFColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: PRFColors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          context,
                          Icons.explore_rounded,
                          'Missions',
                          memberEngagement.missionStats.totalMissions
                              .toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          context,
                          Icons.favorite_rounded,
                          'Souls Touched',
                          memberEngagement.impactStats.soulsTouched.toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          context,
                          Icons.workspace_premium_rounded,
                          'Courses',
                          memberEngagement.learningStats.coursesCompleted
                              .toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          context,
                          Icons.event_rounded,
                          'Events',
                          memberEngagement.eventStats.eventsAttended.toString(),
                        ),
                      ],
                    ),
                  )
                  .animate(delay: 300.ms)
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
              const SizedBox(height: 24),
              Text(
                    "Let's make next year even better! 🚀",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 800.ms)
                  .then(delay: 500.ms)
                  .shimmer(duration: 2000.ms, color: PRFColors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PRFColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: PRFColors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: PRFColors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: PRFColors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
