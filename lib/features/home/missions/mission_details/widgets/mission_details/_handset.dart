import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                mission.school!.name.toUpperCase(),
                style: CustomTextTheme.customTextTheme().bodySmall,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.missionStart(
                      Misc.formatDate(mission.startDate),
                      Misc.formatTime(mission.startTime),
                    ),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.missionEnd(
                      Misc.formatDate(mission.endDate),
                      Misc.formatTime(mission.endTime),
                    ),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.theme,
                style: CustomTextTheme.customTextTheme().headlineMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.theme!,
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.population(mission.school!.totalStudents),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.missionariesRequested(mission.capacity),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.missionariesNeeded(mission.missionSubscriptionsNeeded),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.missionPrepNotes,
                style: CustomTextTheme.customTextTheme().headlineMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.missionPrepNotes.toString(),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.contactPersons,
                style: CustomTextTheme.customTextTheme().headlineMedium,
              ),
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
                      style: CustomTextTheme.customTextTheme().bodySmall,
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
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    l10n.address,
                    style: CustomTextTheme.customTextTheme().headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final school = mission.school!;

                      final isGoogleMapAvaialable =
                          await MapLauncher.isMapAvailable(MapType.google);

                      if (isGoogleMapAvaialable ?? false) {
                        await MapLauncher.showMarker(
                          mapType: MapType.google,
                          coords: Coords(
                            school.latitude,
                            school.longitude,
                          ),
                          title: school.name,
                        );
                        return;
                      }

                      final isGoogleGoMapAvailable =
                          await MapLauncher.isMapAvailable(MapType.googleGo);

                      if (isGoogleGoMapAvailable ?? false) {
                        await MapLauncher.showMarker(
                          mapType: MapType.googleGo,
                          coords: Coords(
                            school.latitude,
                            school.longitude,
                          ),
                          title: school.name,
                        );
                        return;
                      }

                      final isAppleMapAvailable =
                          await MapLauncher.isMapAvailable(MapType.apple);

                      if (isAppleMapAvailable ?? false) {
                        await MapLauncher.showMarker(
                          mapType: MapType.apple,
                          coords: Coords(
                            school.latitude,
                            school.longitude,
                          ),
                          title: school.name,
                        );
                        return;
                      }
                    },
                    icon: const Icon(Icons.map_rounded),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.school!.address,
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    mission.school!.directions.toString(),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    l10n.depaturePlanning,
                    style: CustomTextTheme.customTextTheme().headlineMedium,
                  ),
                  const Spacer(),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.estimatedDistance(mission.school!.distance.toString()),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.estimatedTravelTime(
                      mission.school!.staticDuration.toString(),
                    ),
                    style: CustomTextTheme.customTextTheme().bodySmall,
                  ),
                  Text(
                    l10n.estimationDisclaimer,
                    style: CustomTextTheme.customTextTheme()
                        .bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.weather,
                style: CustomTextTheme.customTextTheme().headlineMedium,
              ),
            ),
            ...mission.weatherForecasts.map(
              (forecast) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.day(
                    mission.weatherForecasts.indexOf(forecast) + 1,
                    forecast.weatherCodeDescription,
                  ),
                  style: CustomTextTheme.customTextTheme().headlineMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: <Widget>[
                    Text(
                      l10n.temperature(
                        forecast.temperature.apparentMin,
                        forecast.temperature.apparentMax,
                        forecast.temperature.apparentAvg,
                      ),
                      style: CustomTextTheme.customTextTheme().bodySmall,
                    ),
                    Text(
                      l10n.humidity(
                        forecast.humidity.min,
                        forecast.humidity.max,
                        forecast.humidity.avg,
                      ),
                      style: CustomTextTheme.customTextTheme().bodySmall,
                    ),
                    Text(
                      l10n.visibility(
                        forecast.visibility.min,
                        forecast.visibility.max,
                        forecast.visibility.avg,
                      ),
                      style: CustomTextTheme.customTextTheme().bodySmall,
                    ),
                    Text(
                      l10n.precipitationProbability(
                        forecast.precipitationProbability.min,
                        forecast.precipitationProbability.max,
                        forecast.precipitationProbability.avg,
                      ),
                      style: CustomTextTheme.customTextTheme().bodySmall,
                    ),
                    Text(
                      l10n.dressingRecommendations,
                      style: CustomTextTheme.customTextTheme().headlineMedium,
                    ),
                    Text(
                      forecast.dressingRecommendations,
                      style: CustomTextTheme.customTextTheme().bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
