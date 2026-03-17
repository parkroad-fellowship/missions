import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsViewHandset extends StatefulWidget {
  const EventDetailsViewHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<EventDetailsViewHandset> createState() =>
      _EventDetailsViewHandsetState();
}

class _EventDetailsViewHandsetState extends State<EventDetailsViewHandset>
    with TimezoneMixin {
  PRFEvent get event => widget.event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        child: Column(
          children: [
            // Hero Event Card
            _buildHeroCard(context, event, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Quick Actions Row
            _buildQuickActions(context, event, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Event Intelligence Grid
            _buildIntelligenceGrid(context, event, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Description Section
            _buildDescriptionSection(context, event, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Location & Navigation Hub
            _buildLocationHub(context, event, l10n, theme),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Weather Intelligence
            if (event.weatherForecasts.isNotEmpty)
              _buildWeatherIntelligence(context, event, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    PRFEvent event,
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
                        'EVENT',
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
                        Icons.event_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                Text(
                  event.name.toUpperCase(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                if (event.venue != null)
                  Text(
                    event.venue!,
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
                          event.startDate,
                          timezone,
                        ),
                        DateFormatter.formatTime(event.startTime, timezone),
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
                          event.endDate,
                          timezone,
                        ),
                        DateFormatter.formatTime(event.endTime, timezone),
                      ),
                      theme,
                    ),
                  ],
                ),
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
    PRFEvent event,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                Icons.map_rounded,
                l10n.navigate,
                theme.colorScheme.tertiary,
                () => _openMap(event),
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
    PRFEvent event,
    AppLocalizations l10n,
    ThemeData theme,
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
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  context,
                  Icons.people_rounded,
                  l10n.capacity,
                  event.capacity != 0 ? event.capacity.toString() : 'N/A',
                  theme.colorScheme.primary,
                  theme,
                ),
                _buildStatCard(
                  context,
                  Icons.group_add_rounded,
                  l10n.subscriptionsNeeded(''),
                  event.subscriptionsNeeded?.toString() ?? 'N/A',
                  theme.colorScheme.secondary,
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

  Widget _buildDescriptionSection(
    BuildContext context,
    PRFEvent event,
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
        )
        .animate(delay: PRFMotionTokens.enterShort)
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildLocationHub(
    BuildContext context,
    PRFEvent event,
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
                      onPressed: () => _openMap(event),
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
                        event.venue ?? 'Venue not specified',
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
        )
        .animate(delay: PRFMotionTokens.enterShort)
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildWeatherIntelligence(
    BuildContext context,
    PRFEvent event,
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
                            color: Colors.black.withValues(alpha: 0.05),
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
        )
        .animate(delay: const Duration(milliseconds: 700))
        .fadeIn(duration: PRFMotionTokens.enterShort)
        .slideY(begin: 0.3, end: 0);
  }

  Future<void> _openMap(PRFEvent event) async {
    if (event.latitude == null || event.longitude == null) {
      return;
    }

    final latitude = event.latitude!;
    final longitude = event.longitude!;

    final isGoogleMapAvailable = await MapLauncher.isMapAvailable(
      MapType.google,
    );

    if (isGoogleMapAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(latitude, longitude),
        title: event.venue ?? '',
      );
      return;
    }

    final isGoogleGoMapAvailable = await MapLauncher.isMapAvailable(
      MapType.googleGo,
    );

    if (isGoogleGoMapAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.googleGo,
        coords: Coords(latitude, longitude),
        title: event.venue ?? '',
      );
      return;
    }

    final isAppleMapAvailable = await MapLauncher.isMapAvailable(MapType.apple);

    if (isAppleMapAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.apple,
        coords: Coords(latitude, longitude),
        title: event.venue ?? '',
      );
      return;
    }
  }
}
