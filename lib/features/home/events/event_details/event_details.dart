import 'package:app/features/home/events/event_details/_handset.dart';
import 'package:app/features/home/events/event_details/_tablet.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => EventDetailsPageTablet(event: event),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => EventDetailsPageHandset(event: event),
      ),
    );
  }
}
