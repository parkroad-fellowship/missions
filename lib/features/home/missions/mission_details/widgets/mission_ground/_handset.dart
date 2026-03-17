import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:prf_design/prf_design.dart';

class MissionGroundViewHandset extends StatefulWidget {
  const MissionGroundViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionGroundViewHandset> createState() =>
      _MissionGroundViewHandsetState();
}

class _MissionGroundViewHandsetState extends State<MissionGroundViewHandset>
    with TimezoneMixin {
  String get missionUlid => widget.missionUlid;
  String get memberUlid => getIt<HiveService>().retrieveMember()!.ulid;

  @override
  void initState() {
    super.initState();

    context.read<MissionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleStreamWrapper<PRFLocalMission?>(
      stream: getIt<IsarService>().missions.itemStream,
      loading: const PRFLinearProgressIndicator(),
      widget: (context, mission) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.sm),
        children: [
          // Hero Mission Card
          _buildHeroCard(context, mission!, l10n, theme),
          const SizedBox(height: PRFSpacingTokens.xl),

          // Quick Actions Row
          _buildQuickActions(context, mission, l10n, theme),
          const SizedBox(height: PRFSpacingTokens.xl),

          // Mission Intelligence Grid
          _buildIntelligenceGrid(context, mission, l10n, theme),
          const SizedBox(height: PRFSpacingTokens.xl),

          // Hide the contact center if the person isn't subscribed
          // and when the mission date has passed
          if (mission.loggedInMemberMissionSubscription != null &&
              mission.loggedInMemberMissionSubscription!.status ==
                  PRFMissionSubscriptionStatus.approved &&
              mission.endDate.isAfter(
                DateTime.now().subtract(const Duration(days: 1)),
              )) ...[
            // Contact Command Center
            _buildContactCenter(context, mission, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),
          ],

          // Location & Navigation Hub
          _buildLocationHub(context, mission, l10n, theme),
          const SizedBox(height: PRFSpacingTokens.xl),

          // Weather Intelligence
          if (mission.weatherForecasts?.isNotEmpty ?? false)
            _buildWeatherIntelligence(context, mission, l10n, theme),
        ],
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.md,
                        vertical: PRFSpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                      ),
                      child: Text(
                        mission.status.name.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                Text(
                  mission.school!.name!.toUpperCase(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                Text(
                  mission.theme!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.xl),
                Row(
                  children: [
                    _buildDateTimeChip(
                      context,
                      Icons.play_arrow_rounded,
                      l10n.missionStart(
                        DateFormatter.formatMissionDate(
                          mission.startDate,
                          timezone,
                        ),
                        DateFormatter.formatTime(mission.startTime, timezone),
                      ),
                      theme,
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                Row(
                  children: [
                    _buildDateTimeChip(
                      context,
                      Icons.stop_rounded,
                      l10n.missionEnd(
                        DateFormatter.formatMissionDate(
                          mission.endDate,
                          timezone,
                        ),
                        DateFormatter.formatTime(mission.endTime, timezone),
                      ),
                      theme,
                    ),
                  ],
                ),
                if (mission.missionPrepNotes?.isNotEmpty ?? false) ...[
                  const SizedBox(height: PRFSpacingTokens.lg),
                  _buildPrepNotes(context, mission, l10n, theme),
                ],
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildDateTimeChip(
    BuildContext context,
    IconData icon,
    String text,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: PRFSpacingTokens.sm),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Row(
          children: [
            if (mission.whatsAppLink != null &&
                mission.loggedInMemberMissionSubscription != null &&
                mission.loggedInMemberMissionSubscription!.status ==
                    PRFMissionSubscriptionStatus.approved)
              Expanded(
                child: _buildActionButton(
                  context,
                  Icons.chat_rounded,
                  l10n.joinWhatsApp,
                  theme.colorScheme.secondary,
                  () => UrlHelper.openUrl(Uri.parse(mission.whatsAppLink!)),
                  theme,
                ),
              ),
            if (mission.whatsAppLink != null &&
                mission.loggedInMemberMissionSubscription != null &&
                mission.loggedInMemberMissionSubscription!.status ==
                    PRFMissionSubscriptionStatus.approved)
              const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: _buildActionButton(
                context,
                Icons.map_rounded,
                l10n.navigate,
                theme.colorScheme.tertiary,
                () => _openMap(mission),
                theme,
              ),
            ),
          ],
        )
        .animate(delay: PRFMotionTokens.standard)
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: PRFSpacingTokens.lg,
          horizontal: PRFSpacingTokens.xl,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: PRFSpacingTokens.sm),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntelligenceGrid(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.missionIntelligence,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                if (mission.school!.totalStudents != 0)
                  _buildStatCard(
                    context,
                    Icons.people_rounded,
                    l10n.population,
                    mission.school!.totalStudents!.toString(),
                    theme.colorScheme.primary,
                    theme,
                  ),
                _buildStatCard(
                  context,
                  Icons.person_add_rounded,
                  l10n.missionariesRequested,
                  mission.capacity.toString(),
                  theme.colorScheme.secondary,
                  theme,
                ),
                _buildStatCard(
                  context,
                  Icons.group_add_rounded,
                  l10n.missionariesNeeded,
                  mission.missionSubscriptionsNeeded.toString(),
                  theme.colorScheme.tertiary,
                  theme,
                ),
                _buildStatCard(
                  context,
                  Icons.route_rounded,
                  l10n.estimatedDistance,
                  mission.school!.distance ?? 'N/A',
                  theme.colorScheme.error,
                  theme,
                ),
              ],
            ),
          ],
        )
        .animate(delay: PRFMotionTokens.slow)
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCenter(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: Icon(
                      Icons.contact_phone_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Text(
                    l10n.contactPersons,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              ...mission.school!.contacts!.map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
                  child: Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            contact.name!.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: PRFSpacingTokens.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.name!,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                contact.contactType!.name!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.sm,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              if (mission.status ==
                                      PRFMissionStatus.fullySubscribed ||
                                  mission.status == PRFMissionStatus.approved) {
                                final uri = Uri(
                                  scheme: 'tel',
                                  path: contact.phone,
                                );
                                await UrlHelper.openUrl(uri);
                              }
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ).animate(
                          effects: const [
                            ShakeEffect(
                              duration: Duration(seconds: 2),
                              delay: PRFMotionTokens.enterShort,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: PRFMotionTokens.enterShort)
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildLocationHub(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.tertiary.withValues(alpha: 0.1),
                theme.colorScheme.tertiary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Expanded(
                    child: Text(
                      l10n.address,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: IconButton(
                      onPressed: () => _openMap(mission),
                      icon: const Icon(
                        Icons.map_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ).animate(
                    effects: const [
                      ShakeEffect(
                        duration: Duration(seconds: 2),
                        delay: PRFMotionTokens.enterShort,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.school!.address!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (mission.school!.directions?.isNotEmpty ?? false) ...[
                      const SizedBox(height: PRFSpacingTokens.sm),
                      Text(
                        mission.school!.directions!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildTravelInfo(
                      context,
                      Icons.straighten_rounded,
                      l10n.estimatedDistance,
                      mission.school!.distance ?? 'N/A',
                      theme,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Expanded(
                    child: _buildTravelInfo(
                      context,
                      Icons.schedule_rounded,
                      'Travel Time',
                      mission.school!.staticDuration ?? 'N/A',
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: Text(
                        l10n.estimationDisclaimer,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: const Duration(milliseconds: 800))
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildTravelInfo(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.tertiary, size: 20),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.tertiary,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIntelligence(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.secondary.withValues(alpha: 0.1),
                theme.colorScheme.secondary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Text(
                    l10n.weather,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              ...mission.weatherForecasts!.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: PRFSpacingTokens.lg),
                  child: _buildWeatherCard(
                    context,
                    entry.key + 1,
                    entry.value,
                    l10n,
                    theme,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: const Duration(milliseconds: 1000))
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildWeatherCard(
    BuildContext context,
    int day,
    PRFLocalWeatherForecast forecast,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.sm,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.xs),
                ),
                child: Text(
                  'Day $day',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.sm),
              Expanded(
                child: Text(
                  forecast.weatherCodeDescription!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.md),
          Row(
            children: [
              Expanded(
                child: _buildWeatherStat(
                  context,
                  l10n.temperature,
                  '${forecast.temperature!.apparentAvg!}°',
                  theme,
                ),
              ),
              Expanded(
                child: _buildWeatherStat(
                  context,
                  l10n.humidity,
                  forecast.humidity!.avg!,
                  theme,
                ),
              ),
              Expanded(
                child: _buildWeatherStat(
                  context,
                  l10n.rain,
                  forecast.precipitationProbability!.avg!,
                  theme,
                ),
              ),
            ],
          ),
          if (forecast.dressingRecommendations?.isNotEmpty ?? false) ...[
            const SizedBox(height: PRFSpacingTokens.md),
            Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.checkroom_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Expanded(
                    child: Text(
                      forecast.dressingRecommendations!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeatherStat(
    BuildContext context,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.secondary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPrepNotes(
    BuildContext context,
    PRFLocalMission mission,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Icon(
                  Icons.note_alt_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Text(
                l10n.missionPrepNotes,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
            ),
            child: Text(
              mission.missionPrepNotes!,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMap(PRFLocalMission mission) async {
    final school = mission.school!;

    final mapTypes = [MapType.google, MapType.googleGo, MapType.apple];

    for (final mapType in mapTypes) {
      final isAvailable = await MapLauncher.isMapAvailable(mapType);
      if (isAvailable) {
        await MapLauncher.showMarker(
          mapType: mapType,
          coords: Coords(school.latitude!, school.longitude!),
          title: school.name!,
        );
        return;
      }
    }
  }
}
