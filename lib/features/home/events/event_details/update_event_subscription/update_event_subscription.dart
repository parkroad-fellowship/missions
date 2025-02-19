import 'package:app/features/home/events/event_details/update_event_subscription/_handset.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateEventSubscriptionView extends StatelessWidget {
  const UpdateEventSubscriptionView({required this.event, super.key});

  final PRFEvent event;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, __) => UpdateEventSubscriptionViewHandset(event: event),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => UpdateEventSubscriptionViewHandset(event: event),
      ),
    );
  }
}
