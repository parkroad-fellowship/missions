import 'package:app/models/remote/prf_mission_session.dart';
import 'package:flutter/material.dart';

class SessionPageHandset extends StatefulWidget {
  const SessionPageHandset({
    required this.missionSession,
    super.key,
  });

  final PRFMissionSession missionSession;

  @override
  State<SessionPageHandset> createState() => _SessionPageHandsetState();
}

class _SessionPageHandsetState extends State<SessionPageHandset> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
