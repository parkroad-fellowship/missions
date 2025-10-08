import 'dart:async';

import 'package:app/models/local/prf_member_mission.dart';
import 'package:app/models/local/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class MemberMissionDbService
    extends BaseLocalDBService<PRFMissionSubscription, PRFLocalMemberMission> {
  MemberMissionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMemberMission> get collection =>
      dbInstance.pRFLocalMemberMissions;

  @override
  PRFLocalMemberMission remoteToLocal(PRFMissionSubscription remote) {
    final mission = remote.mission!;
    final missionType = mission.missionType!;
    final school = mission.school!;
    final contacts = mission.school!.contacts!;
    final weatherForecasts = mission.weatherForecasts;

    return PRFLocalMemberMission(
      ulid: mission.ulid,
      startDate: mission.startDate,
      startTime: mission.startTime,
      endDate: mission.endDate,
      endTime: mission.endTime,
      missionPrepNotes: mission.missionPrepNotes,
      theme: mission.theme,
      whatsAppLink: mission.whatsAppLink,
      capacity: mission.capacity,
      status: mission.status,
      missionSubscriptionsNeeded: mission.missionSubscriptionsNeeded,
      createdAt: mission.createdAt,
      updatedAt: mission.updatedAt,
      loggedInMemberMissionSubscription: PRFLocalMissionMemberSubscription(
        ulid: remote.ulid,
        status: remote.status,
        missionRole: remote.missionRole,
        createdAt: remote.createdAt,
        updatedAt: remote.updatedAt,
      ),
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

  Future<List<PRFLocalMission>> listParentMissions() async {
    return collection.where().sortByStartDateDesc().findAll().then(
      (localMemberMissions) => localMemberMissions
          .map(_transformLocalMemberMissionToLocalMission)
          .toList(),
    );
  }

  Stream<List<PRFLocalMission>> getAllParents() {
    return collection
        .where()
        .sortByStartDateDesc()
        .watch(fireImmediately: true)
        .asBroadcastStream()
        .map(
          (localMissions) => localMissions
              .map(_transformLocalMemberMissionToLocalMission)
              .toList(),
        );
  }

  StreamController<List<PRFLocalMission>>? _parentStreamController;
  Stream<List<PRFLocalMission>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalMission>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream() async {
    _parentStreamController ??=
        StreamController<List<PRFLocalMission>>.broadcast();
    final entities = await listParentMissions();
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }

  PRFLocalMission _transformLocalMemberMissionToLocalMission(
    PRFLocalMemberMission localMemberMission,
  ) {
    final mission = localMemberMission;
    final missionType = mission.missionType!;
    final school = mission.school!;
    final contacts = mission.school!.contacts!;
    final weatherForecasts = mission.weatherForecasts;
    final missionSubscription = mission.loggedInMemberMissionSubscription!;

    return PRFLocalMission(
      ulid: mission.ulid,
      startDate: mission.startDate,
      startTime: mission.startTime,
      endDate: mission.endDate,
      endTime: mission.endTime,
      missionPrepNotes: mission.missionPrepNotes,
      theme: mission.theme,
      whatsAppLink: mission.whatsAppLink,
      capacity: mission.capacity,
      status: mission.status,
      missionSubscriptionsNeeded: mission.missionSubscriptionsNeeded,
      createdAt: mission.createdAt,
      updatedAt: mission.updatedAt,
      loggedInMemberMissionSubscription: PRFLocalMissionMemberSubscription(
        ulid: missionSubscription.ulid,
        status: missionSubscription.status,
        missionRole: missionSubscription.missionRole,
        createdAt: missionSubscription.createdAt,
        updatedAt: missionSubscription.updatedAt,
      ),
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
          ?.map(
            (weatherForecast) => PRFLocalWeatherForecast(
              ulid: weatherForecast.ulid,
              forecastDate: weatherForecast.forecastDate,
              weatherCodeDescription: weatherForecast.weatherCodeDescription,
              temperature: PRFLocalTemperature(
                apparentAvg: weatherForecast.temperature?.apparentAvg,
                apparentMin: weatherForecast.temperature?.apparentMin,
                apparentMax: weatherForecast.temperature?.apparentMax,
                avg: weatherForecast.temperature?.avg,
                min: weatherForecast.temperature?.min,
                max: weatherForecast.temperature?.max,
              ),
              visibility: PRFLocalVisibility(
                avg: weatherForecast.visibility?.avg,
                min: weatherForecast.visibility?.min,
                max: weatherForecast.visibility?.max,
              ),
              precipitationProbability: PRFLocalPrecipitationProbability(
                avg: weatherForecast.precipitationProbability?.avg,
                min: weatherForecast.precipitationProbability?.min,
                max: weatherForecast.precipitationProbability?.max,
              ),
              humidity: PRFLocalHumidity(
                avg: weatherForecast.humidity?.avg,
                min: weatherForecast.humidity?.min,
                max: weatherForecast.humidity?.max,
              ),
              dressingRecommendations: weatherForecast.dressingRecommendations,
              activityRecommendations: weatherForecast.activityRecommendations,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> persistEntities(
    List<PRFMissionSubscription> remoteEntities,
  ) async {
    await dbInstance.writeTxn(() async {
      final localEntities = remoteEntities.map(remoteToLocal).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
        ..reversed;
      await collection.putAll(localEntities);
    });
  }
}
