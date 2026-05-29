import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion_dto.dart';
import 'package:app/services/api/mission_ground_suggestion_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class GroundSuggestionResourceCubit
    extends ResourceCubit<PRFMissionGroundSuggestion> {
  GroundSuggestionResourceCubit({
    required MissionGroundSuggestionService missionGroundSuggestionService,
    required HiveService hiveService,
  }) : _hiveService = hiveService,
       super(
         service: missionGroundSuggestionService,
         dbService: hiveService.missionGroundSuggestions,
       );

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => ['suggestor'];

  /// Create a ground suggestion.
  Future<void> createSuggestion({
    required String name,
    required String contactPerson,
    required String contactNumber,
  }) async {
    final dto = PRFMissionGroundSuggestionDTO(
      name: name,
      suggestorUlid: _hiveService.retrieveMember()!.ulid,
      contactPerson: contactPerson,
      contactNumber: contactNumber,
    );
    await create(data: dto.toJson());
  }

  /// Update a ground suggestion.
  Future<void> updateSuggestion({
    required String ulid,
    required PRFMissionGroundSuggestionDTO data,
  }) async {
    await update(
      id: ulid,
      data: data.toJson(),
      matchById: (s) => s.ulid == ulid,
    );
  }
}
