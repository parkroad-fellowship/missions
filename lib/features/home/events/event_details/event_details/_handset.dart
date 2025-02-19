import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';

class EventDetailsViewHandset extends StatefulWidget {
  const EventDetailsViewHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<EventDetailsViewHandset> createState() =>
      _EventDetailsViewHandsetState();
}

class _EventDetailsViewHandsetState extends State<EventDetailsViewHandset> {
  PRFEvent get event => widget.event;

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
                event.name.toUpperCase(),
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
                      Misc.formatMissionDate(event.startDate),
                      Misc.formatTime(event.startTime),
                    ),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    l10n.missionEnd(
                      Misc.formatMissionDate(event.endDate),
                      Misc.formatTime(event.endTime),
                    ),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    event.capacity != 0
                        ? l10n.capacity(event.capacity.toString())
                        : l10n.capacity('N/A'),
                    style: PRFText.theme().bodySmall,
                  ),
                  Text(
                    event.subscriptionsNeeded != null
                        ? l10n.subscriptionsNeeded(event.subscriptionsNeeded.toString())
                        : l10n.subscriptionsNeeded('N/A'),
                    style: PRFText.theme().bodySmall,
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.description,
                style: PRFText.theme().headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(event.description, style: PRFText.theme().bodySmall),
                ],
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
                        if (event.latitude != null && event.longitude != null) {
                          return;
                        }

                        final latitude = event.latitude!;
                        final longitude = event.longitude!;

                        final isGoogleMapAvaialable =
                            await MapLauncher.isMapAvailable(MapType.google);

                        if (isGoogleMapAvaialable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(latitude, longitude),
                            title: event.venue ?? '',
                          );
                          return;
                        }

                        final isGoogleGoMapAvailable =
                            await MapLauncher.isMapAvailable(MapType.googleGo);

                        if (isGoogleGoMapAvailable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.googleGo,
                            coords: Coords(latitude, longitude),
                            title: event.venue ?? '',
                          );
                          return;
                        }

                        final isAppleMapAvailable =
                            await MapLauncher.isMapAvailable(MapType.apple);

                        if (isAppleMapAvailable ?? false) {
                          await MapLauncher.showMarker(
                            mapType: MapType.apple,
                            coords: Coords(latitude, longitude),
                            title: event.venue ?? '',
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
                  Text(event.venue ?? '', style: PRFText.theme().bodySmall),
                ],
              ),
            ),
            SizedBox(height: 8.h),
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
            ...event.weatherForecasts.map(
              (forecast) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.day(
                    event.weatherForecasts.indexOf(forecast) + 1,
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
