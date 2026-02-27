import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_ground_suggestions_state.dart';
part 'get_mission_ground_suggestions_cubit.freezed.dart';

class GetMissionGroundSuggestionsCubit
    extends Cubit<GetMissionGroundSuggestionsState> {
  GetMissionGroundSuggestionsCubit({
    required MissionGroundSuggestionService missionGroundSuggestionService,
    required HiveService hiveService,
  }) : super(const GetMissionGroundSuggestionsState.initial()) {
    _hiveService = hiveService;
    _missionGroundSuggestionService = missionGroundSuggestionService;
  }

  late MissionGroundSuggestionService _missionGroundSuggestionService;
  late HiveService _hiveService;

  Future<void> getMissionGroundSuggestions() async {
    try {
      final member = _hiveService.retrieveMember()!;

      final viewAnyMissionGrounds = PermissionHelper.userCan(
        'viewAny mission ground suggestion',
      );

      final suggestorUlid = viewAnyMissionGrounds ? null : member.ulid;
      final statusKeys = viewAnyMissionGrounds
          ? [
              PRFMissionGroundSuggestionStatus.pending,
              PRFMissionGroundSuggestionStatus.initiatedContact,
            ]
          : <PRFMissionGroundSuggestionStatus>[];

      final missionGroundSuggestions = await _missionGroundSuggestionService
          .list(
            filters: {
              'suggestor_ulid': ?suggestorUlid,
              'status_keys': statusKeys
                  .map((status) => status.apiKey)
                  .join(','),
            },
            includes: ['suggestor'],
          );

      if (missionGroundSuggestions.isEmpty) {
        emit(const GetMissionGroundSuggestionsState.empty());
        return;
      }

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
