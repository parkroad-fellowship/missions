import 'package:app/features/events/event_details/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:auto_route/auto_route.dart';
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

    return PRFTabletSplitScaffold(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PRFTabletHeaderRow(
            title: l10n.eventDetails,
            onBack: () => context.router.maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                PRFSpacingTokens.lg,
                0,
                PRFSpacingTokens.lg,
                PRFSpacingTokens.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        .animate(delay: PRFMotionTokens.slow)
                        .fadeIn(duration: PRFMotionTokens.enterShort)
                        .slideY(begin: 0.15, end: 0),
                    const SizedBox(height: PRFSpacingTokens.xl),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      sidePanel: Column(
        children: [
          Expanded(
            child: PRFBrandPanel(
              children: [
                // Hero banner card (navy gradient — sits natively on the panel)
                EventHeroCard(event: event),
                const SizedBox(height: PRFSpacingTokens.xl),

                // Location & Navigation Hub on a light card for legibility
                Material(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                  child: Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.md),
                    child: buildEventLocationHub(
                      context,
                      theme,
                      l10n,
                      event,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.md),

          // Pinned navigation CTA below the scrollable brand panel
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
            ),
            child: PRFButton(
              variant: PRFButtonVariant.secondary,
              onPressed: () => openMap(event),
              title: l10n.navigate,
            ),
          ),
        ],
      ),
    );
  }
}
