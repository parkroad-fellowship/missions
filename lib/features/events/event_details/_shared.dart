import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsFormState {
  void attach(VoidCallback rebuild) {}
  void dispose() {}
}

Future<void> openMap(PRFEvent event) async {
  if (event.latitude == null || event.longitude == null) {
    return;
  }

  final maps =
      await MapLauncher.marker(
        LocationCoords(
          event.latitude!,
          event.longitude!,
          title: event.venue ?? '',
        ),
      ).getSupportedMaps(
        [MapApp.google, MapApp.googleGo, MapApp.apple],
      );

  await maps.first.show();
}

class DateTimeChip extends StatelessWidget {
  const DateTimeChip({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: PRFColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: PRFColors.white, size: 16),
          const SizedBox(width: PRFSpacingTokens.sm),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: PRFColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class EventHeroCard extends StatelessWidget with TimezoneMixin {
  const EventHeroCard({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

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
                    color: PRFColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                  ),
                  child: Text(
                    'EVENT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                  decoration: BoxDecoration(
                    color: PRFColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      PRFRadiusTokens.smd,
                    ),
                  ),
                  child: const Icon(
                    Icons.event_rounded,
                    color: PRFColors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Text(
              event.name.toUpperCase(),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: PRFColors.white,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
            if (event.venue != null)
              Text(
                event.venue!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: PRFColors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: PRFSpacingTokens.xl),
            Row(
              children: [
                DateTimeChip(
                  icon: Icons.play_arrow_rounded,
                  text: l10n.missionStart(
                    DateFormatter.formatMissionDate(
                      event.startDate,
                      timezone,
                    ),
                    DateFormatter.formatTime(event.startTime, timezone),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
            Row(
              children: [
                DateTimeChip(
                  icon: Icons.stop_rounded,
                  text: l10n.missionEnd(
                    DateFormatter.formatMissionDate(
                      event.endDate,
                      timezone,
                    ),
                    DateFormatter.formatTime(event.endTime, timezone),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EventStatCard extends StatelessWidget {
  const EventStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            label.replaceAll(RegExp(r'\{.*?\}'), '').trim(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildEventDescriptionSection(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFEvent event,
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
                Icons.description_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Text(
              l10n.description,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          event.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

Widget buildEventIntelligence(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFEvent event,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.eventIntelligence,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: PRFSpacingTokens.lg),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: PRFSpacingTokens.md,
        crossAxisSpacing: PRFSpacingTokens.md,
        childAspectRatio: 1.2,
        children: [
          EventStatCard(
            icon: Icons.people_rounded,
            label: l10n.capacity,
            value: event.capacity != 0 ? event.capacity.toString() : 'N/A',
            color: theme.colorScheme.primary,
          ),
          EventStatCard(
            icon: Icons.group_add_rounded,
            label: l10n.subscriptionsNeeded(''),
            value: event.subscriptionsNeeded?.toString() ?? 'N/A',
            color: theme.colorScheme.secondary,
          ),
        ],
      ),
    ],
  );
}

Widget buildEventLocationHub(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFEvent event,
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
            Text(
              l10n.address,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
              ),
              child: IconButton(
                onPressed: () => openMap(event),
                icon: const Icon(
                  Icons.map_rounded,
                  color: PRFColors.white,
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
            boxShadow: [
              BoxShadow(
                color: PRFColors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Icon(
                  Icons.place_rounded,
                  color: theme.colorScheme.tertiary,
                  size: 16,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Expanded(
                child: Text(
                  event.venue ?? l10n.venueNotSpecified,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildEventWeatherIntelligence(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFEvent event,
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
        ...event.weatherForecasts.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final forecast = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
              child: Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    PRFRadiusTokens.smd,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PRFColors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.day(
                        index + 1,
                        forecast.weatherCodeDescription,
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.sm),
                    Text(
                      l10n.visibility(
                        forecast.visibility.min,
                        forecast.visibility.max,
                        forecast.visibility.avg,
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      l10n.precipitationProbability(
                        forecast.precipitationProbability.min,
                        forecast.precipitationProbability.max,
                        forecast.precipitationProbability.avg,
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: PRFSpacingTokens.sm),
                    Text(
                      l10n.dressingRecommendations,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      forecast.dressingRecommendations,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
