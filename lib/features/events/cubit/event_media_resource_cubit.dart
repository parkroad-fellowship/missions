import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';

/// Manages event media. Uses custom API calls (listChildren)
/// because media are child resources of an event.
class EventMediaResourceCubit extends Cubit<ResourceState<PRFMedia>> {
  EventMediaResourceCubit({
    required this._eventService,
  }) : super(const ResourceState.initial());

  final EventService _eventService;

  /// Load event media by model collection.
  Future<void> loadMedia({
    required String eventUlid,
    required PRFMediaModel model,
  }) async {
    emit(const ResourceState.listLoading());
    try {
      final media = await _eventService.listChildren(
        parentId: eventUlid,
        childPath: 'media',
        queryParameters: {
          'collection': model.collection,
        },
        fromJson: (json) => PRFMediaResponse.fromJson(json).data,
      );

      emit(ResourceState.listLoaded(items: media));
    } catch (e) {
      emit(ResourceState.error(message: e.toString()));
    }
  }

  /// Reset to initial state.
  void reset() => emit(const ResourceState.initial());
}
