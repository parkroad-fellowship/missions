import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/member/prf_responsible_desk.dart';
import 'package:app/enums/mission/prf_mission_role.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/local/mission/prf_member_mission.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/media/prf_weather_forecast.dart';
import 'package:app/models/remote/member/prf_contact.dart';
import 'package:app/models/remote/member/prf_contact_type.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_type.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/isar/mission_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission> {
  MissionResourceCubit({
    required MissionService missionService,
    super.dbService,
  }) : super(service: missionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    await dbService?.refreshStream();
  }

  @override
  Future<PRFMission?> loadCachedItem(String id) async {
    if (dbService is! MissionDbService) {
      return null;
    }

    final localMission = await (dbService! as MissionDbService).get(id);
    if (localMission == null) {
      return null;
    }

    return _toRemoteMission(localMission);
  }

  Future<void> loadMission({
    required String missionUlid,
    bool refresh = false,
  }) async {
    await loadOne(
      id: missionUlid,
      refresh: refresh,
      matchById: (mission) => mission.ulid == missionUlid,
    );
  }

  @override
  List<String> get defaultIncludes => [
    'school',
    'schoolTerm',
    'missionType',
    'school.schoolContacts.contactType',
    'loggedInMemberMissionSubscription',
    'weatherForecasts',
    'accountingEvent',
  ];

  @override
  Map<String, dynamic> get defaultFilters => {
    'upcoming': true,
    'status_keys': [
      PRFMissionStatus.approved.apiKey,
      PRFMissionStatus.fullySubscribed.apiKey,
    ].join(','),
  };

  @override
  String? get defaultSortBy => '-start_date';

  PRFMission _toRemoteMission(PRFLocalMission local) {
    final school = local.school;
    final missionType = local.missionType;
    final subscription = local.loggedInMemberMissionSubscription;

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
              school.ulid ?? 'cached-school',
              school.name ?? 'Cached School',
              school.totalStudents ?? 0,
              school.institutionType ?? PRFInstitutionType.highSchool,
              school.address ?? 'Unknown',
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
                      contact.ulid ?? 'cached-contact',
                      contact.name ?? 'Unknown',
                      contact.phone ?? 'N/A',
                      local.createdAt,
                      local.updatedAt,
                      contactType: PRFContactType(
                        contact.contactType?.ulid ?? 'cached-contact-type',
                        contact.contactType?.name ?? 'Contact',
                        local.createdAt,
                        local.updatedAt,
                      ),
                    ),
                  )
                  .toList(),
            ),
      missionType: missionType == null
          ? null
          : PRFMissionType(
              missionType.ulid ?? 'cached-mission-type',
              missionType.name ?? 'Mission',
              missionType.isActive ?? 1,
              missionType.createdAt ?? local.createdAt,
              missionType.updatedAt ?? local.updatedAt,
            ),
      loggedInMemberMissionSubscription: subscription == null
          ? null
          : _toRemoteSubscription(subscription, local),
      accountingEvent: PRFAccountingEvent(
        local.accountingEventUlid,
        'Cached Accounting Event',
        local.endDate,
        PRFResponsibleDesk.missions,
        0,
        0,
        0,
        0,
        0,
        local.createdAt,
        local.updatedAt,
      ),
      weatherForecasts: (local.weatherForecasts ?? <PRFLocalWeatherForecast>[])
          .map(
            (forecast) => PRFWeatherForecast(
              forecast.ulid ?? 'cached-weather',
              forecast.forecastDate ?? '',
              forecast.weatherCodeDescription ?? 'N/A',
              PRFTemperature(
                forecast.temperature?.apparentAvg ?? '0',
                forecast.temperature?.apparentMax ?? '0',
                forecast.temperature?.apparentMin ?? '0',
                forecast.temperature?.avg ?? '0',
                forecast.temperature?.max ?? '0',
                forecast.temperature?.min ?? '0',
              ),
              PRFVisibility(
                forecast.visibility?.avg ?? '0',
                forecast.visibility?.max ?? '0',
                forecast.visibility?.min ?? '0',
              ),
              PRFPrecipitationProbability(
                forecast.precipitationProbability?.avg ?? '0',
                forecast.precipitationProbability?.max ?? '0',
                forecast.precipitationProbability?.min ?? '0',
              ),
              PRFHumidity(
                forecast.humidity?.avg ?? '0',
                forecast.humidity?.max ?? '0',
                forecast.humidity?.min ?? '0',
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

  PRFMissionSubscription _toRemoteSubscription(
    PRFLocalMissionMemberSubscription local,
    PRFLocalMission mission,
  ) {
    return PRFMissionSubscription(
      local.ulid ?? 'cached-subscription-${mission.ulid}',
      local.status ?? PRFMissionSubscriptionStatus.pending,
      local.missionRole ?? PRFMissionRole.member,
      local.createdAt ?? mission.createdAt,
      local.updatedAt ?? mission.updatedAt,
    );
  }
}
