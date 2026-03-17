import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/services/api/mission_ground_suggestion_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class GroundSuggestionResourceCubit
    extends ResourceCubit<PRFMissionGroundSuggestion> {
  GroundSuggestionResourceCubit({
    required MissionGroundSuggestionService missionGroundSuggestionService,
    super.dbService,
  }) : super(service: missionGroundSuggestionService);

  @override
  List<String> get defaultIncludes => ['suggestor'];

  /// Create a ground suggestion.
  Future<void> createSuggestion({
    required Map<String, dynamic> data,
  }) async {
    await create(data: data);
  }

  /// Update a ground suggestion.
  Future<void> updateSuggestion({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (s) => s.ulid == ulid,
    );
  }
}
