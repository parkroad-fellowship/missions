import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'get_member_mission_subscriptions_state.dart';
part 'get_member_mission_subscriptions_cubit.freezed.dart';

class GetMemberMissionSubscriptionsCubit
    extends Cubit<GetMemberMissionSubscriptionsState> {
  GetMemberMissionSubscriptionsCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required HiveService hiveService,
    required IsarService isarService,
  }) : super(const GetMemberMissionSubscriptionsState.initial()) {
    _missionSubscriptionService = missionSubscriptionService;
    _hiveService = hiveService;
    _isarService = isarService;
  }

  late MissionSubscriptionService _missionSubscriptionService;
  late HiveService _hiveService;
  late IsarService _isarService;

  Future<void> getSubscriptions({bool refresh = false}) async {
    emit(const GetMemberMissionSubscriptionsState.loading());
    try {
      if (!refresh) {
        await _isarService.memberMissions.refreshParentStream();
        emit(const GetMemberMissionSubscriptionsState.loaded());
        return;
      }

      final member = _hiveService.retrieveMember()!;
      final missionSubscriptions = await _missionSubscriptionService.list(
        includes: [
          'mission.missionType,mission.school',
          'mission.school.schoolContacts.contactType',
          'mission.weatherForecasts',
          'mission.accountingEvent',
        ],
        filters: {
          'member_ulid': member.ulid,
          'status_keys': [
            PRFMissionSubscriptionStatus.approved.apiKey,
            PRFMissionSubscriptionStatus.withdrawn.apiKey,
            PRFMissionSubscriptionStatus.pending.apiKey,
            PRFMissionSubscriptionStatus.fullySubscribed.apiKey,
            PRFMissionSubscriptionStatus.conflict.apiKey,
          ].join(','),
        },
      );

      await _isarService.memberMissions.persistEntities(missionSubscriptions);
      await _isarService.memberMissions.refreshParentStream();

      // Update the missions entries with the loggedInMemberMissionSubscription
      // This is to ensure that when we access to the contacts and extra details
      for (final subscription in missionSubscriptions) {
        final mission = subscription.mission;
        if (mission != null) {
          await _isarService.missions.persistEntity(
            mission.copyWith(
              loggedInMemberMissionSubscription: PRFMissionSubscription(
                subscription.ulid,
                subscription.status,
                subscription.missionRole,
                subscription.createdAt,
                subscription.updatedAt,
              ),
            ),
          );
        }
      }

      emit(const GetMemberMissionSubscriptionsState.loaded());
    } on Failure catch (e) {
      emit(GetMemberMissionSubscriptionsState.error(e.message));
    } catch (e, s) {
      Logger().e(e.toString(), stackTrace: s);
      emit(GetMemberMissionSubscriptionsState.error(e.toString()));
    }
  }
}
