import 'package:app/features/missions/mission_details/widgets/gallery/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => GalleryViewHandset(mission: mission),
      builder: (_, _) => GalleryViewHandset(mission: mission),
    );
  }
}
