import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_event_media_state.dart';
part 'get_event_media_cubit.freezed.dart';

class GetEventMediaCubit extends Cubit<GetEventMediaState> {
  GetEventMediaCubit({
    required EventService eventService,
  }) : super(GetEventMediaState.initial()) {
    _eventService = eventService;
  }

  late EventService _eventService;

  Future<void> getEventMedia({
    required String eventUlid,
    required PRFMediaModel model,
  }) async {
    emit(const GetEventMediaState.loading());
    try {
      final media = await _eventService.getEventMedia(
        eventUlid: eventUlid,
        model: model,
      );

      if (media.isEmpty) {
        emit(const GetEventMediaState.empty());
        return;
      }
      emit(GetEventMediaState.loaded(media: media));
    } catch (e) {
      emit(GetEventMediaState.error(e.toString()));
    }
  }
}
