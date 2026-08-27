import 'package:app/features/events/event_details/actions/add_event_subscription/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddEventSubscriptionView extends StatelessWidget {
  const AddEventSubscriptionView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => AddEventSubscriptionViewHandset(event: event),
      builder: (_, _) => AddEventSubscriptionViewHandset(event: event),
    );
  }
}
