import 'package:app/features/home/events/event_details/event_details/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => EventDetailsViewHandset(event: event),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => EventDetailsViewHandset(event: event),
      ),
    );
  }
}
