import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';

/// Manages mission media. Uses custom API calls (listChildren/deleteChild)
/// instead of standard CRUD because media are child resources of a mission.
class MissionMediaResourceCubit extends Cubit<ResourceState<PRFMedia>> {
  MissionMediaResourceCubit({
    required MissionService missionService,
  }) : _missionService = missionService,
       super(const ResourceState.initial());

  final MissionService _missionService;

  /// Current items from any state.
  List<PRFMedia> get currentItems {
    return state.maybeWhen(
      listLoaded: (items, _, _) => items,
      mutating: (items, _) => items,
      error: (_, items) => items,
      orElse: () => [],
    );
  }

  /// Load mission media by collections.
  Future<void> loadMedia({
    required String missionUlid,
    required List<PRFMediaModel> collections,
  }) async {
    emit(const ResourceState.listLoading());
    try {
      final media = await _missionService.listChildren<PRFMedia>(
        parentId: missionUlid,
        childPath: 'media',
        queryParameters: {
          'collections': collections
              .map((e) => e.collection)
              .toList()
              .join(','),
        },
        fromJson: (json) => PRFMediaResponse.fromJson(json).data,
      );

      emit(ResourceState.listLoaded(items: media));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Delete a media item from a mission.
  Future<void> deleteMedia({
    required String missionUlid,
    required String mediaUuid,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.delete,
      ),
    );
    try {
      await _missionService.deleteChild(
        parentId: missionUlid,
        childPath: 'media',
        childId: mediaUuid,
        apiVersion: 'v2',
      );
      final updated = currentItems.where((m) => m.uuid != mediaUuid).toList();
      emit(ResourceState.listLoaded(items: updated));
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Reset to initial state.
  void reset() => emit(const ResourceState.initial());
}
