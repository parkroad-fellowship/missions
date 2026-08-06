import 'package:app/features/events/event_details/actions/update_event_subscription/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class UpdateEventSubscriptionView extends StatelessWidget {
  const UpdateEventSubscriptionView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => UpdateEventSubscriptionViewHandset(event: event),
      builder: (_, _) => UpdateEventSubscriptionViewHandset(event: event),
    );
  }
}
