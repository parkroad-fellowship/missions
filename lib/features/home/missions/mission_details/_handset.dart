import 'package:app/enums/prf_mission_status.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';

class MissionsDetailsPageHandset extends StatefulWidget {
  const MissionsDetailsPageHandset({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  State<MissionsDetailsPageHandset> createState() =>
      _MissionsDetailsPageHandsetState();
}

class _MissionsDetailsPageHandsetState
    extends State<MissionsDetailsPageHandset> {
  PRFMission get mission => widget.mission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.missionDetails,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
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
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ).name,
                    ),
                    backgroundColor: PRFMissionStatusExtension.switchColor(
                      PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ) ==
                      PRFMissionStatus.approved)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      width: MediaQuery.sizeOf(context).height * 0.2,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              l10n.sendMe,
                              style: CustomTextTheme.customTextTheme()
                                  .displayLarge!
                                  .copyWith(
                                    color: AppTheme.appTheme().kBackgroundColor,
                                    fontSize: 14,
                                  ),
                            ),
                            Icon(
                              Icons.hail_rounded,
                              size: 16,
                              color: AppTheme.appTheme().kBackgroundColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
