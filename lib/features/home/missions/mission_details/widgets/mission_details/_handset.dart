import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';

class MissionDetailsViewHandset extends StatefulWidget {
  const MissionDetailsViewHandset({required this.mission, super.key});

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
    Misc.initDimensions(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                mission.school!.name.toUpperCase(),
                style: PRFText.theme().headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Text(
                    l10n.missionStart(
                      Misc.formatMissionDate(mission.startDate),
                      Misc.formatTime(mission.startTime),
                    ),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.missionEnd(
                      Misc.formatMissionDate(mission.endDate),
                      Misc.formatTime(mission.endTime),
                    ),
                    style: PRFText.theme().bodySmall,
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.theme,
                style: PRFText.theme().headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: <Widget>[
                  Text(mission.theme!, style: PRFText.theme().bodySmall),
                  Text(
                    l10n.population(mission.school!.totalStudents),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.missionariesRequested(mission.capacity),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.missionariesNeeded(mission.missionSubscriptionsNeeded),
                    style: PRFText.theme().bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.missionPrepNotes,
                style: PRFText.theme().headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.missionPrepNotes.toString(),
                    style: PRFText.theme().bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.contactPersons,
                style: PRFText.theme().headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
                      style: PRFText.theme().bodySmall,
                    ),
                  ],
                ),
                trailing: Animate(
                  effects: const [
                    ShakeEffect(
                      duration: Duration(seconds: 2),
                      delay: Duration(milliseconds: 500),
                    ),
                  ],
                  child: IconButton(
                    onPressed: () async {
                      final uri = Uri(scheme: 'tel', path: contact.phone);
                      await Misc.openUrl(uri);
                    },
                    icon: const Icon(Icons.phone),
                  ),
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
                    style: PRFText.theme().headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Animate(
                    effects: const [
                      ShakeEffect(
                        duration: Duration(seconds: 2),
                        delay: Duration(milliseconds: 500),
                      ),
                    ],
                    child: IconButton(
                      onPressed: () async {
                        final school = mission.school!;

                        final isGoogleMapAvaialable =
                            await MapLauncher.isMapAvailable(MapType.google);

                        if (isGoogleMapAvaialable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(school.latitude, school.longitude),
                            title: school.name,
                          );
                          return;
                        }

                        final isGoogleGoMapAvailable =
                            await MapLauncher.isMapAvailable(MapType.googleGo);

                        if (isGoogleGoMapAvailable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.googleGo,
                            coords: Coords(school.latitude, school.longitude),
                            title: school.name,
                          );
                          return;
                        }

                        final isAppleMapAvailable =
                            await MapLauncher.isMapAvailable(MapType.apple);

                        if (isAppleMapAvailable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.apple,
                            coords: Coords(school.latitude, school.longitude),
                            title: school.name,
                          );
                          return;
                        }
                      },
                      icon: const Icon(Icons.map_rounded),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mission.school!.address,
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    mission.school!.directions.toString(),
                    style: PRFText.theme().bodySmall,
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
                    style: PRFText.theme().headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.estimatedDistance(mission.school!.distance.toString()),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.estimatedTravelTime(
                      mission.school!.staticDuration.toString(),
                    ),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.estimationDisclaimer,
                    style: PRFText.theme().bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            if (mission.weatherForecasts.isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.weather,
                  style: PRFText.theme().headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
                  style: PRFText.theme().headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: <Widget>[
                    Text(
                      l10n.temperature(
                        forecast.temperature.apparentMin,
                        forecast.temperature.apparentMax,
                        forecast.temperature.apparentAvg,
                      ),
                      style: PRFText.theme().bodySmall,
                    ),
                    Text(
                      l10n.humidity(
                        forecast.humidity.min,
                        forecast.humidity.max,
                        forecast.humidity.avg,
                      ),
                      style: PRFText.theme().bodySmall,
                    ),
                    Text(
                      l10n.visibility(
                        forecast.visibility.min,
                        forecast.visibility.max,
                        forecast.visibility.avg,
                      ),
                      style: PRFText.theme().bodySmall,
                    ),
                    Text(
                      l10n.precipitationProbability(
                        forecast.precipitationProbability.min,
                        forecast.precipitationProbability.max,
                        forecast.precipitationProbability.avg,
                      ),
                      style: PRFText.theme().bodySmall,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.dressingRecommendations,
                      style: PRFText.theme().headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      forecast.dressingRecommendations.toString(),
                      style: PRFText.theme().bodySmall,
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
