import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_media_cubit.freezed.dart';
part 'delete_media_state.dart';

class DeleteMediaCubit extends Cubit<DeleteMediaState> {
  DeleteMediaCubit({
    required MissionService missionService,
  }) : super(const DeleteMediaState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> deleteMedia({
    required String missionUlid,
    required String mediaUuid,
  }) async {
    emit(const DeleteMediaState.loading());
    try {
      await _missionService.deleteChild(
        parentId: missionUlid,
        childPath: 'media',
        childId: mediaUuid,
      );
      emit(const DeleteMediaState.loaded());
    } on Failure catch (e) {
      emit(DeleteMediaState.error(e.message));
    } catch (e) {
      emit(DeleteMediaState.error(e.toString()));
    }
  }
}
