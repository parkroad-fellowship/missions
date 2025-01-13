import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_media_state.dart';
part 'get_mission_media_cubit.freezed.dart';

class GetMissionMediaCubit extends Cubit<GetMissionMediaState> {
  GetMissionMediaCubit({
    required MissionService missionService,
  }) : super(const GetMissionMediaState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> getMissionMedia({
    required String missionUlid,
    required PRFMediaModel model,
  }) async {
    emit(const GetMissionMediaState.loading());
    try {
      final media = await _missionService.getMissionMedia(
        missionUlid: missionUlid,
        model: model,
      );
      emit(GetMissionMediaState.loaded(media: media));
    } catch (e) {
      emit(GetMissionMediaState.error(e.toString()));
    }
  }
}
