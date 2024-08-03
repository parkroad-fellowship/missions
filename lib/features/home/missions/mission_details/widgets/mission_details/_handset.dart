import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
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
            title: Text(mission.school!.name.toUpperCase()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.missionStart(
                    Misc.formatDate(mission.startDate),
                    Misc.formatTime(mission.startTime),
                  ),
                ),
                Text(
                  l10n.missionEnd(
                    Misc.formatDate(mission.endDate),
                    Misc.formatTime(mission.endTime),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.theme),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(mission.theme!),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.population(mission.school!.totalStudents)),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.missionariesRequested(mission.capacity)),
            subtitle: Text(
              l10n.missionariesNeeded(
                mission.missionSubscriptionsNeeded,
              ),
            ),
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
            title: Text(l10n.contactPersons),
          ),
          ...mission.school!.contacts!.map(
            (contact) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(contact.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contact.contactType!.name,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () async {
                  final uri = Uri(
                    scheme: 'tel',
                    path: contact.phone,
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                icon: const Icon(Icons.phone),
              ),
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
