import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

part 'add_mission_ground_suggestion_state.dart';
part 'add_mission_ground_suggestion_cubit.freezed.dart';

class AddMissionGroundSuggestionCubit
    extends Cubit<AddMissionGroundSuggestionState> {
  AddMissionGroundSuggestionCubit({
    required HiveService hiveService,
    required MissionGroundsService missionGroundsService,
  }) : super(const AddMissionGroundSuggestionState.initial()) {
    _missionGroundsService = missionGroundsService;
    _hiveService = hiveService;
  }

  late HiveService _hiveService;
  late MissionGroundsService _missionGroundsService;

  Future<void> suggestMissionGround({
    required String name,
    required String contactPerson,
    required PhoneNumber contactNumber,
  }) async {
    try {
      emit(const AddMissionGroundSuggestionState.loading());
      final member = _hiveService.retrieveMember()!;

      final missionGroundSuggestion = await _missionGroundsService
          .createMissionGroundSuggestion(
            missionGroundSuggestionDTO: PRFMissionGroundSuggestionDTO(
              name: name,
              contactPerson: contactPerson,
              contactNumber: contactNumber.parseNumber(),
              suggestorUlid: member.ulid,
            ),
          );
      emit(
        AddMissionGroundSuggestionState.loaded(
          missionGroundSuggestion: missionGroundSuggestion,
        ),
      );
    } on Failure catch (e) {
      emit(AddMissionGroundSuggestionState.error(e.message));
    } catch (e) {
      emit(AddMissionGroundSuggestionState.error(e.toString()));
    }
  }
}
