import 'package:app/features/events/event_details/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsPageHandset extends StatefulWidget {
  const EventDetailsPageHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<EventDetailsPageHandset> createState() =>
      _EventDetailsPageHandsetState();
}

class _EventDetailsPageHandsetState extends State<EventDetailsPageHandset>
    with TimezoneMixin {
  PRFEvent get event => widget.event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: PRFAppBar(
        title: l10n.eventDetails,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          child: Column(
            children: [
              // Hero Event Card
              EventHeroCard(event: event)
                  .animate()
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),

              // Quick Actions Row
              Row(
                    children: [
                      Expanded(
                        child: PRFButton(
                          variant: PRFButtonVariant.secondary,
                          onPressed: () => openMap(event),
                          title: l10n.navigate,
                        ),
                      ),
                    ],
                  )
                  .animate(delay: PRFMotionTokens.standard)
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),

              // Event Intelligence Grid
              buildEventIntelligence(context, theme, l10n, event)
                  .animate(delay: PRFMotionTokens.slow)
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),

              // Description Section
              buildEventDescriptionSection(context, theme, l10n, event)
                  .animate(delay: PRFMotionTokens.enterShort)
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),

              // Location & Navigation Hub
              buildEventLocationHub(context, theme, l10n, event)
                  .animate(delay: PRFMotionTokens.enterShort)
                  .fadeIn(duration: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: PRFSpacingTokens.xl),

              // Weather Intelligence
              if (event.weatherForecasts.isNotEmpty)
                buildEventWeatherIntelligence(context, theme, l10n, event)
                    .animate(delay: const Duration(milliseconds: 700))
                    .fadeIn(duration: PRFMotionTokens.enterShort)
                    .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
