import 'package:app/features/events/event_details/gallery/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class EventGalleryView extends StatelessWidget {
  const EventGalleryView({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => EventGalleryViewHandset(eventUlid: eventUlid),
      builder: (_, _) => EventGalleryViewHandset(eventUlid: eventUlid),
    );
  }
}
