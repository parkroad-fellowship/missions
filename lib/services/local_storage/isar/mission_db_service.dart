import 'dart:async';

import 'package:app/models/local/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class MissionDbService extends BaseLocalDBService<PRFMission, PRFLocalMission> {
  MissionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMission> get collection => dbInstance.pRFLocalMissions;

  @override
  PRFLocalMission remoteToLocal(PRFMission remote) {
    final missionType = remote.missionType!;
    final school = remote.school!;
    final contacts = remote.school!.contacts!;
    final weatherForecasts = remote.weatherForecasts;

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
  Future<PRFLocalMission?> getByKeyFuture(String key) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }

  @override
  Stream<PRFLocalMission?> getByKey(String key) {
    final v = collection
        .where()
        .ulidEqualTo(key)
        .watch(fireImmediately: true)
        .asBroadcastStream()
        .map((results) => results.isEmpty ? null : results.first);

    return v;
  }

  Future<void> refreshMissions() async {
    getAll();
  }
}
