import 'package:app/l10n/l10n.dart';
import 'package:app/models/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    // final uri = Uri.parse(
                    //   'geo:'
                    //   'q=${school.latitude},${school.longitude}&mode=d',
                    // );
                    final uri = Uri(
                      scheme: 'geo',
                      host: '0,0',
                      queryParameters: {
                        'q': '${school.latitude},${school.longitude}',
                        'mode': 'd',
                      },
                    );
                    try {
                      await launchUrl(uri);
                    } catch (e) {
                      Logger().e(e);
                    }
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
