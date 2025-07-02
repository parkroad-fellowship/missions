import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_ground_suggestion_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_ground_suggestion_state.dart';
part 'update_mission_ground_suggestion_cubit.freezed.dart';

class UpdateMissionGroundSuggestionCubit
    extends Cubit<UpdateMissionGroundSuggestionState> {
  UpdateMissionGroundSuggestionCubit({
    required HiveService hiveService,
    required MissionGroundSuggestionService missionGroundSuggestionService,
  }) : super(const UpdateMissionGroundSuggestionState.initial()) {
    _missionGroundSuggestionService = missionGroundSuggestionService;
    _hiveService = hiveService;
  }

  late HiveService _hiveService;
  late MissionGroundSuggestionService _missionGroundSuggestionService;

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

      final missionGroundSuggestion = await _missionGroundSuggestionService
          .update(
            id: missionGroundSuggestionUlid,
            data: PRFMissionGroundSuggestionDTO(
              name: name,
              contactPerson: contactPerson,
              contactNumber: contactNumber,
              suggestorUlid: member.ulid,
              status: status,
              notes: notes,
            ).toJson(),
            includes: 'suggestor',
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
