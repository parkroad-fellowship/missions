import 'package:app/l10n/l10n.dart';
import 'package:app/models/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MissionDetailsViewHandset extends StatefulWidget {
  const MissionDetailsViewHandset({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  State<MissionDetailsViewHandset> createState() =>
      _MissionDetailsViewHandsetState();
}

class _MissionDetailsViewHandsetState extends State<MissionDetailsViewHandset> {
  PRFMission get mission => widget.mission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.population(mission.school!.totalStudents)),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.missionPrepNotes),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(mission.missionPrepNotes),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Text(l10n.address),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    final school = mission.school!;
                    await MapsLauncher.launchCoordinates(
                      school.latitude,
                      school.longitude,
                    );
                  },
                  icon: const Icon(Icons.map_rounded),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(mission.school!.address),
                Text(mission.school!.directions.toString()),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
