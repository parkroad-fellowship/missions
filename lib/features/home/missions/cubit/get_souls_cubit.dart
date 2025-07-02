import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_souls_state.dart';
part 'get_souls_cubit.freezed.dart';

class GetSoulsCubit extends Cubit<GetSoulsState> {
  GetSoulsCubit({
    required SoulService soulService,
    required LocalDBService localDBService,
  }) : super(const GetSoulsState.initial()) {
    _soulService = soulService;
    _localDBService = localDBService;
  }

  late SoulService _soulService;
  late LocalDBService _localDBService;

  Future<void> getSouls({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetSoulsState.loading());
    try {
      if (!refresh) {
        emit(const GetSoulsState.loaded());
        return;
      }

      final souls = await _soulService.list(
        filters: {
          'filter[mission_ulid]': missionUlid,
        },
        includes: 'classGroup',
      );
      await _localDBService.persistSouls(
        souls: souls,
        missionUlid: missionUlid,
      );
      emit(const GetSoulsState.loaded());
    } on Failure catch (e) {
      emit(GetSoulsState.error(e.message));
    } catch (e) {
      emit(GetSoulsState.error(e.toString()));
    }
  }
}
