import 'package:app/features/events/event_details/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsPageTablet extends StatefulWidget {
  const EventDetailsPageTablet({required this.event, super.key});

  final PRFEvent event;

  @override
  State<EventDetailsPageTablet> createState() => _EventDetailsPageTabletState();
}

class _EventDetailsPageTabletState extends State<EventDetailsPageTablet> {
  PRFEvent get event => widget.event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Column - Content details, stats & weather (flex: 3)
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.lg,
                      vertical: PRFSpacingTokens.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: PRFSpacingTokens.xs),
                            Text(
                              l10n.eventDetails,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: PRFSpacingTokens.xl),

                        // Event Intelligence Grid
                        buildEventIntelligence(context, theme, l10n, event)
                            .animate()
                            .fadeIn(duration: PRFMotionTokens.enterShort)
                            .slideY(begin: 0.15, end: 0),
                        const SizedBox(height: PRFSpacingTokens.xl),

                        // Description Section
                        buildEventDescriptionSection(
                              context,
                              theme,
                              l10n,
                              event,
                            )
                            .animate(delay: PRFMotionTokens.standard)
                            .fadeIn(duration: PRFMotionTokens.enterShort)
                            .slideY(begin: 0.15, end: 0),
                        const SizedBox(height: PRFSpacingTokens.xl),

                        // Weather Intelligence Section
                        if (event.weatherForecasts.isNotEmpty) ...[
                          buildEventWeatherIntelligence(
                                context,
                                theme,
                                l10n,
                                event,
                              )
                              .animate(delay: const Duration(milliseconds: 500))
                              .fadeIn(duration: PRFMotionTokens.enterShort)
                              .slideY(begin: 0.15, end: 0),
                          const SizedBox(height: PRFSpacingTokens.xl),
                        ],
                      ],
                    ),
                  ),
                ),

                // Vertical Divider
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.12),
                ),

                // Right Column - Hero card & location hub sidebar (flex: 2)
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Hero banner card
                                EventHeroCard(event: event),
                                const SizedBox(height: PRFSpacingTokens.xl),

                                // Location & Navigation Hub
                                buildEventLocationHub(
                                  context,
                                  theme,
                                  l10n,
                                  event,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.md),

                        // Navigation CTA Button
                        PRFButton(
                          onPressed: () => openMap(event),
                          title: l10n.navigate,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
