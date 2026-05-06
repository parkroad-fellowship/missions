import 'dart:async';

import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/mission/prf_mission_role.dart';
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
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

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
      accountingEvent: PRFLocalAccountingEvent(
        ulid: remote.accountingEvent?.ulid,
        name: remote.accountingEvent?.name,
        dueDate: remote.accountingEvent?.dueDate,
        responsibleDesk: remote.accountingEvent?.responsibleDesk,
        credits: remote.accountingEvent?.credits,
        debits: remote.accountingEvent?.debits,
        balance: remote.accountingEvent?.balance,
        refundCharge: remote.accountingEvent?.refundCharge,
        amountToRefund: remote.accountingEvent?.amountToRefund,
        createdAt: remote.accountingEvent?.createdAt,
        updatedAt: remote.accountingEvent?.updatedAt,
        refunds: remote.accountingEvent?.refunds
            .map(
              (refund) => PRFLocalRefund(
                ulid: refund.ulid,
                amount: refund.amount,
                deficitAmount: refund.deficitAmount,
                confirmationMessage: refund.confirmationMessage,
                createdAt: refund.createdAt,
                updatedAt: refund.updatedAt,
              ),
            )
            .toList(),
      ),
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
  PRFMission localToRemote(PRFLocalMission local) {
    final school = local.school;
    final missionType = local.missionType;
    final localSubscription = local.loggedInMemberMissionSubscription;

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
      loggedInMemberMissionSubscription: localSubscription?.ulid == null
          ? null
          : PRFMissionSubscription(
              localSubscription!.ulid!,
              localSubscription.status ?? PRFMissionSubscriptionStatus.pending,
              localSubscription.missionRole ?? PRFMissionRole.member,
              localSubscription.createdAt ?? local.createdAt,
              localSubscription.updatedAt ?? local.updatedAt,
            ),
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
      accountingEvent: local.accountingEvent.ulid == null
          ? null
          : PRFAccountingEvent(
              local.accountingEvent.ulid!,
              local.accountingEvent.name!,
              local.accountingEvent.dueDate!,
              local.accountingEvent.responsibleDesk!,
              local.accountingEvent.credits!,
              local.accountingEvent.debits!,
              local.accountingEvent.balance!,
              local.accountingEvent.refundCharge!,
              local.accountingEvent.amountToRefund!,
              local.accountingEvent.createdAt!,
              local.accountingEvent.updatedAt!,
              refunds: [],
            ),
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
