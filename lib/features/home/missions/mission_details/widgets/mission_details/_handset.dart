import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_mission.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/progress/linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';

class MissionDetailsViewHandset extends StatefulWidget {
  const MissionDetailsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionDetailsViewHandset> createState() =>
      _MissionDetailsViewHandsetState();
}

class _MissionDetailsViewHandsetState extends State<MissionDetailsViewHandset> {
  String get missionUlid => widget.missionUlid;
  String get timezone => getIt<HiveService>().timezone;
  String get memberUlid => getIt<HiveService>().retrieveMember()!.ulid;

  @override
  void initState() {
    super.initState();
    getIt<LocalDBService>().getMission(missionUlid: missionUlid);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SingleStreamWrapper<PRFLocalMission?>(
              stream: getIt<LocalDBService>().getMission(
                missionUlid: missionUlid,
              ),
              loading: const PRFLinearProgressIndicator(),
              widget:
                  (context, mission) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      mission!.school!.name!.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Text(
                          l10n.missionStart(
                            Misc.formatMissionDate(mission.startDate, timezone),
                            Misc.formatTime(mission.startTime, timezone),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          l10n.missionEnd(
                            Misc.formatMissionDate(mission.endDate, timezone),
                            Misc.formatTime(mission.endTime, timezone),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.theme,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              subtitle: SingleStreamWrapper<PRFLocalMission?>(
                stream: getIt<LocalDBService>().getMission(
                  missionUlid: missionUlid,
                ),
                loading: const PRFLinearProgressIndicator(),
                widget:
                    (context, mission) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: <Widget>[
                        Text(
                          mission!.theme!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          l10n.population(mission.school!.totalStudents!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          l10n.missionariesRequested(mission.capacity),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          l10n.missionariesNeeded(
                            mission.missionSubscriptionsNeeded,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.missionPrepNotes,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              subtitle: SingleStreamWrapper<PRFLocalMission?>(
                stream: getIt<LocalDBService>().getMission(
                  missionUlid: missionUlid,
                ),
                loading: const PRFLinearProgressIndicator(),
                widget:
                    (context, mission) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          mission!.missionPrepNotes.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
              ),
            ),
            SizedBox(height: 8.h),
            SingleStreamWrapper(
              stream: getIt<LocalDBService>().getMission(
                missionUlid: missionUlid,
              ),
              widget:
                  (context, mission) =>
                      (mission!.whatsAppLink != null &&
                              mission.loggedInMemberMissionSubscription !=
                                  null &&
                              mission
                                      .loggedInMemberMissionSubscription!
                                      .status ==
                                  PRFMissionSubscriptionStatus.approved)
                          ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.link),
                            title: Text(
                              l10n.joinWhatsApp,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            onTap:
                                () => Misc.openUrl(
                                  Uri.parse(mission.whatsAppLink!),
                                ),
                          )
                          : const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.contactPersons,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 8.h),
            SingleStreamWrapper(
              stream: getIt<LocalDBService>().getMission(
                missionUlid: missionUlid,
              ),
              widget:
                  (context, mission) => Column(
                    children: [
                      ...mission!.school!.contacts!.map(
                        (contact) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(contact.name!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                contact.contactType!.name!,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.bodySmall,
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
                                final uri = Uri(
                                  scheme: 'tel',
                                  path: contact.phone,
                                );
                                await Misc.openUrl(uri);
                              },
                              icon: const Icon(Icons.phone),
                            ),
                          ),
                        ),
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
                    l10n.address,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  SingleStreamWrapper<PRFLocalMission?>(
                    stream: getIt<LocalDBService>().getMission(
                      missionUlid: missionUlid,
                    ),
                    widget: (context, mission) {
                      return Animate(
                        effects: const [
                          ShakeEffect(
                            duration: Duration(seconds: 2),
                            delay: Duration(milliseconds: 500),
                          ),
                        ],
                        child: IconButton(
                          onPressed: () async {
                            final school = mission!.school!;

                            final isGoogleMapAvaialable =
                                await MapLauncher.isMapAvailable(
                                  MapType.google,
                                );

                            if (isGoogleMapAvaialable ?? false) {
                              await MapLauncher.showMarker(
                                mapType: MapType.google,
                                coords: Coords(
                                  school.latitude!,
                                  school.longitude!,
                                ),
                                title: school.name!,
                              );
                              return;
                            }

                            final isGoogleGoMapAvailable =
                                await MapLauncher.isMapAvailable(
                                  MapType.googleGo,
                                );

                            if (isGoogleGoMapAvailable ?? false) {
                              await MapLauncher.showMarker(
                                mapType: MapType.googleGo,
                                coords: Coords(
                                  school.latitude!,
                                  school.longitude!,
                                ),
                                title: school.name!,
                              );
                              return;
                            }

                            final isAppleMapAvailable =
                                await MapLauncher.isMapAvailable(MapType.apple);

                            if (isAppleMapAvailable ?? false) {
                              await MapLauncher.showMarker(
                                mapType: MapType.apple,
                                coords: Coords(
                                  school.latitude!,
                                  school.longitude!,
                                ),
                                title: school.name!,
                              );
                              return;
                            }
                          },
                          icon: const Icon(Icons.map_rounded),
                        ),
                      );
                    },
                  ),
                ],
              ),
              subtitle: SingleStreamWrapper<PRFLocalMission?>(
                stream: getIt<LocalDBService>().getMission(
                  missionUlid: missionUlid,
                ),
                widget: (context, mission) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        mission!.school!.address!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        mission.school!.directions.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    l10n.depaturePlanning,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                ],
              ),
              subtitle: SingleStreamWrapper<PRFLocalMission?>(
                stream: getIt<LocalDBService>().getMission(
                  missionUlid: missionUlid,
                ),
                widget: (context, mission) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.estimatedDistance(
                          mission!.school!.distance.toString(),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        l10n.estimatedTravelTime(
                          mission.school!.staticDuration.toString(),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        l10n.estimationDisclaimer,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            SingleStreamWrapper(
              stream: getIt<LocalDBService>().getMission(
                missionUlid: missionUlid,
              ),
              widget:
                  (context, mission) => Column(
                    children: [
                      if (mission!.weatherForecasts?.isNotEmpty ?? false)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            l10n.weather,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      if (mission.weatherForecasts?.isNotEmpty ?? false)
                        ...mission.weatherForecasts!.map(
                          (forecast) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              l10n.day(
                                mission.weatherForecasts!.indexOf(forecast) + 1,
                                forecast.weatherCodeDescription!,
                              ),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: <Widget>[
                                Text(
                                  l10n.temperature(
                                    forecast.temperature!.apparentMin!,
                                    forecast.temperature!.apparentMax!,
                                    forecast.temperature!.apparentAvg!,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  l10n.humidity(
                                    forecast.humidity!.min!,
                                    forecast.humidity!.max!,
                                    forecast.humidity!.avg!,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  l10n.visibility(
                                    forecast.visibility!.min!,
                                    forecast.visibility!.max!,
                                    forecast.visibility!.avg!,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  l10n.precipitationProbability(
                                    forecast.precipitationProbability!.min!,
                                    forecast.precipitationProbability!.max!,
                                    forecast.precipitationProbability!.avg!,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  l10n.dressingRecommendations,
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                ),
                                Text(
                                  forecast.dressingRecommendations.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
