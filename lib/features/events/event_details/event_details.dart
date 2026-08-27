import 'package:app/features/events/event_details/_handset.dart';
import 'package:app/features/events/event_details/_tablet.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => EventDetailsPageTablet(event: event),
      handset: (context) => EventDetailsPageHandset(event: event),
      tablet: (context) => EventDetailsPageTablet(event: event),
    );
  }
}
