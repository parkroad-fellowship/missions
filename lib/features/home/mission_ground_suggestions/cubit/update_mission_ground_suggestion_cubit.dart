import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_ground_suggestion_state.dart';
part 'update_mission_ground_suggestion_cubit.freezed.dart';

class UpdateMissionGroundSuggestionCubit
    extends Cubit<UpdateMissionGroundSuggestionState> {
  UpdateMissionGroundSuggestionCubit({
    required HiveService hiveService,
    required MissionGroundsService missionGroundsService,
  }) : super(const UpdateMissionGroundSuggestionState.initial()) {
    _missionGroundsService = missionGroundsService;
    _hiveService = hiveService;
  }

  late HiveService _hiveService;
  late MissionGroundsService _missionGroundsService;

  Future<void> updateMissionGroundSuggestion({
    required String missionGroundSuggestionUlid,
    required String name,
    required String contactPerson,
    required String contactNumber,
    required PRFMissionGroundSuggestionStatus status,
    required String notes,
  }) async {
    try {
      emit(const UpdateMissionGroundSuggestionState.loading());
      final member = _hiveService.retrieveMember()!;

      final missionGroundSuggestion = await _missionGroundsService
          .updateMissionGroundSuggestion(
            missionGroundSuggestionUlid: missionGroundSuggestionUlid,
            missionGroundSuggestionDTO: PRFMissionGroundSuggestionDTO(
              name: name,
              contactPerson: contactPerson,
              contactNumber: contactNumber,
              suggestorUlid: member.ulid,
              status: status,
              notes: notes,
            ),
          );
      emit(
        UpdateMissionGroundSuggestionState.loaded(
          missionGroundSuggestion: missionGroundSuggestion,
        ),
      );
    } on Failure catch (e) {
      emit(UpdateMissionGroundSuggestionState.error(e.message));
    } catch (e) {
      emit(UpdateMissionGroundSuggestionState.error(e.toString()));
    }
  }
}
