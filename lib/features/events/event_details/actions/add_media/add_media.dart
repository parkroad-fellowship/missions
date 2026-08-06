import 'package:app/features/events/event_details/actions/add_media/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddEventMediaView extends StatelessWidget {
  const AddEventMediaView({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => AddEventMediaViewHandset(eventUlid: eventUlid),
      builder: (_, _) => AddEventMediaViewHandset(eventUlid: eventUlid),
    );
  }
}
