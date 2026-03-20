import 'package:app/features/home/events/event_details/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return EventDetailsPageHandset(event: event);
  }
}
