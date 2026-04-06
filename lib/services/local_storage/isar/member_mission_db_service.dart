import 'dart:async';

import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/mission/prf_mission_role.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/local/mission/prf_member_mission.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/media/prf_weather_forecast.dart';
import 'package:app/models/remote/member/prf_contact.dart';
import 'package:app/models/remote/member/prf_contact_type.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_type.dart';
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
    final contacts = school.contacts ?? [];
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
      accountingEventUlid: mission.accountingEvent!.ulid,
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

  @override
  PRFMissionSubscription localToRemote(PRFLocalMemberMission local) {
    final subscription = local.loggedInMemberMissionSubscription;

    return PRFMissionSubscription(
      subscription?.ulid ?? local.ulid,
      subscription?.status ?? PRFMissionSubscriptionStatus.pending,
      subscription?.missionRole ?? PRFMissionRole.member,
      subscription?.createdAt ?? local.createdAt,
      subscription?.updatedAt ?? local.updatedAt,
      mission: _localMissionToRemote(local),
    );
  }

  PRFMission _localMissionToRemote(PRFLocalMemberMission local) {
    final school = local.school;
    final missionType = local.missionType;

    return PRFMission(
      local.ulid,
      local.startDate,
      local.startTime,
      local.endDate,
      local.endTime,
      local.capacity,
      local.status,
      local.missionSubscriptionsNeeded,
      local.createdAt,
      local.updatedAt,
      missionPrepNotes: local.missionPrepNotes,
      theme: local.theme,
      whatsAppLink: local.whatsAppLink,
      school: school == null
          ? null
          : PRFSchool(
              school.ulid ?? '',
              school.name ?? '',
              school.totalStudents ?? 0,
              school.institutionType ?? PRFInstitutionType.highSchool,
              school.address ?? '',
              school.latitude ?? 0,
              school.longitude ?? 0,
              1,
              school.createdAt ?? local.createdAt,
              school.updatedAt ?? local.updatedAt,
              description: school.description ?? 'N/A',
              directions: school.directions ?? 'N/A',
              distance: school.distance ?? 'N/A',
              staticDuration: school.staticDuration ?? 'N/A',
              contacts: school.contacts
                  ?.map(
                    (contact) => PRFContact(
                      contact.ulid ?? '',
                      contact.name ?? '',
                      contact.phone ?? '',
                      school.createdAt ?? local.createdAt,
                      school.updatedAt ?? local.updatedAt,
                      contactType: contact.contactType == null
                          ? null
                          : PRFContactType(
                              contact.contactType!.ulid ?? '',
                              contact.contactType!.name ?? '',
                              school.createdAt ?? local.createdAt,
                              school.updatedAt ?? local.updatedAt,
                            ),
                    ),
                  )
                  .toList(),
            ),
      missionType: missionType == null
          ? null
          : PRFMissionType(
              missionType.ulid ?? '',
              missionType.name ?? '',
              missionType.isActive ?? 1,
              missionType.createdAt ?? local.createdAt,
              missionType.updatedAt ?? local.updatedAt,
            ),
      weatherForecasts: (local.weatherForecasts ?? [])
          .map(
            (forecast) => PRFWeatherForecast(
              forecast.ulid ?? '',
              forecast.forecastDate ?? '',
              forecast.weatherCodeDescription ?? '',
              PRFTemperature(
                forecast.temperature?.apparentAvg ?? '',
                forecast.temperature?.apparentMax ?? '',
                forecast.temperature?.apparentMin ?? '',
                forecast.temperature?.avg ?? '',
                forecast.temperature?.max ?? '',
                forecast.temperature?.min ?? '',
              ),
              PRFVisibility(
                forecast.visibility?.avg ?? '',
                forecast.visibility?.max ?? '',
                forecast.visibility?.min ?? '',
              ),
              PRFPrecipitationProbability(
                forecast.precipitationProbability?.avg ?? '',
                forecast.precipitationProbability?.max ?? '',
                forecast.precipitationProbability?.min ?? '',
              ),
              PRFHumidity(
                forecast.humidity?.avg ?? '',
                forecast.humidity?.max ?? '',
                forecast.humidity?.min ?? '',
              ),
              dressingRecommendations:
                  forecast.dressingRecommendations ?? 'N/A',
              activityRecommendations:
                  forecast.activityRecommendations ?? 'N/A',
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
      accountingEventUlid: mission.accountingEventUlid,
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
