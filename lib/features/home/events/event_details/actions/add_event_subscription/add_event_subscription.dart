import 'package:app/features/home/events/event_details/actions/add_event_subscription/_handset.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddEventSubscriptionView extends StatelessWidget {
  const AddEventSubscriptionView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => AddEventSubscriptionViewHandset(event: event),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddEventSubscriptionViewHandset(event: event),
      ),
    );
  }
}
