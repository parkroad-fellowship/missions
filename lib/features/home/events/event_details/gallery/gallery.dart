import 'package:app/features/home/events/event_details/gallery/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class EventGalleryView extends StatelessWidget {
  const EventGalleryView({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => EventGalleryViewHandset(eventUlid: eventUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => EventGalleryViewHandset(eventUlid: eventUlid),
      ),
    );
  }
}
