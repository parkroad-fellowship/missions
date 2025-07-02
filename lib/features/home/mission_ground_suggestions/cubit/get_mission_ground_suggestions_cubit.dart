import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_ground_suggestions_state.dart';
part 'get_mission_ground_suggestions_cubit.freezed.dart';

class GetMissionGroundSuggestionsCubit
    extends Cubit<GetMissionGroundSuggestionsState> {
  GetMissionGroundSuggestionsCubit({
    required MissionGroundsService missionGroundsService,
    required HiveService hiveService,
  }) : super(const GetMissionGroundSuggestionsState.initial()) {
    _hiveService = hiveService;
    _missionGroundsService = missionGroundsService;
  }

  late MissionGroundsService _missionGroundsService;
  late HiveService _hiveService;

  Future<void> getMissionGroundSuggestions() async {
    try {
      final member = _hiveService.retrieveMember()!;

      final viewAnyMissionGrounds = Misc.userCan(
        'viewAny mission ground suggestion',
      );

      final missionGroundSuggestions = await _missionGroundsService
          .getMissionGroundSuggestions(
            suggestorUlid: viewAnyMissionGrounds ? null : member.ulid,
            statuses: viewAnyMissionGrounds
                ? [
                    PRFMissionGroundSuggestionStatus.pending,
                    PRFMissionGroundSuggestionStatus.initiatedContact,
                  ]
                : [],
          );

      emit(
        GetMissionGroundSuggestionsState.loaded(
          missionGroundSuggestions: missionGroundSuggestions,
        ),
      );
    } on Failure catch (e) {
      emit(GetMissionGroundSuggestionsState.error(e.message));
    } catch (e) {
      emit(GetMissionGroundSuggestionsState.error(e.toString()));
    }
  }
}
