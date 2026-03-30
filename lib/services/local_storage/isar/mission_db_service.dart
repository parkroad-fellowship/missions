import 'dart:async';

import 'package:app/models/local/mission/prf_member_mission.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class MissionDbService extends BaseLocalDBService<PRFMission, PRFLocalMission> {
  MissionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMission> get collection => dbInstance.pRFLocalMissions;

  @override
  PRFLocalMission remoteToLocal(PRFMission remote) {
    Logger().f('Converting PRFMission with ulid ${remote.ulid} to PRFLocalMission');
    Logger().w(remote.toJson());

    final missionType = remote.missionType!;
    final school = remote.school!;
    final contacts = remote.school!.contacts!;
    final weatherForecasts = remote.weatherForecasts;
    final loggedInMemberMissionSubscription =
        remote.loggedInMemberMissionSubscription;

    return PRFLocalMission(
      ulid: remote.ulid,
      startDate: remote.startDate,
      startTime: remote.startTime,
      endDate: remote.endDate,
      endTime: remote.endTime,
      missionPrepNotes: remote.missionPrepNotes,
      theme: remote.theme,
      capacity: remote.capacity,
      status: remote.status,
      missionSubscriptionsNeeded: remote.missionSubscriptionsNeeded,
      accountingEventUlid: remote.accountingEvent!.ulid,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      missionType: PRFLocalMissionType(
        ulid: missionType.ulid,
        name: missionType.name,
        isActive: missionType.isActive,
        createdAt: missionType.createdAt,
        updatedAt: missionType.updatedAt,
      ),
      school: PRFLocalSchool(
        ulid: school.ulid,
        name: school.name,
        address: school.address,
        staticDuration: school.staticDuration,
        totalStudents: school.totalStudents,
        createdAt: school.createdAt,
        updatedAt: school.updatedAt,
        description: school.description,
        directions: school.directions,
        distance: school.distance,
        latitude: school.latitude,
        longitude: school.longitude,
        institutionType: school.institutionType,
        contacts: contacts
            .map(
              (contact) => PRFLocalContact(
                ulid: contact.ulid,
                name: contact.name,
                phone: contact.phone,
                contactType: PRFLocalContactType(
                  ulid: contact.contactType!.ulid,
                  name: contact.contactType!.name,
                ),
              ),
            )
            .toList(),
      ),
      loggedInMemberMissionSubscription: PRFLocalMissionMemberSubscription(
        ulid: loggedInMemberMissionSubscription?.ulid,
        status: loggedInMemberMissionSubscription?.status,
        missionRole: loggedInMemberMissionSubscription?.missionRole,
        createdAt: loggedInMemberMissionSubscription?.createdAt,
        updatedAt: loggedInMemberMissionSubscription?.updatedAt,
      ),
      weatherForecasts: weatherForecasts
          .map(
            (weatherForecast) => PRFLocalWeatherForecast(
              ulid: weatherForecast.ulid,
              forecastDate: weatherForecast.forecastDate,
              weatherCodeDescription: weatherForecast.weatherCodeDescription,
              temperature: PRFLocalTemperature(
                apparentAvg: weatherForecast.temperature.apparentAvg,
                apparentMin: weatherForecast.temperature.apparentMin,
                apparentMax: weatherForecast.temperature.apparentMax,
                avg: weatherForecast.temperature.avg,
                min: weatherForecast.temperature.min,
                max: weatherForecast.temperature.max,
              ),
              visibility: PRFLocalVisibility(
                avg: weatherForecast.visibility.avg,
                min: weatherForecast.visibility.min,
                max: weatherForecast.visibility.max,
              ),
              precipitationProbability: PRFLocalPrecipitationProbability(
                avg: weatherForecast.precipitationProbability.avg,
                min: weatherForecast.precipitationProbability.min,
                max: weatherForecast.precipitationProbability.max,
              ),
              humidity: PRFLocalHumidity(
                avg: weatherForecast.humidity.avg,
                min: weatherForecast.humidity.min,
                max: weatherForecast.humidity.max,
              ),
              dressingRecommendations: weatherForecast.dressingRecommendations,
              activityRecommendations: weatherForecast.activityRecommendations,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<PRFLocalMission?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }

  @override
  Future<void> refreshStream() async {
    streamController ??= StreamController<List<PRFLocalMission>>.broadcast();
    final entities = await list();
    entities.removeWhere(
      (element) => element.startDate.isBefore(
        DateTime.now(),
      ),
    );
    streamController!.add(entities);
  }
}
