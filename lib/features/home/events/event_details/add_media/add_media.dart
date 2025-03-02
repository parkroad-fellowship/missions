import 'package:app/features/home/events/event_details/add_media/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddEventMediaView extends StatelessWidget {
  const AddEventMediaView({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => AddEventMediaViewHandset(eventUlid: eventUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddEventMediaViewHandset(eventUlid: eventUlid),
      ),
    );
  }
}
