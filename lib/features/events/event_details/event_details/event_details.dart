import 'package:app/features/events/event_details/event_details/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => EventDetailsViewHandset(event: event),
      builder: (_, _) => EventDetailsViewHandset(event: event),
    );
  }
}
