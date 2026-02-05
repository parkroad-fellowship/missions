import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_souls_state.dart';
part 'get_souls_cubit.freezed.dart';

class GetSoulsCubit extends Cubit<GetSoulsState> {
  GetSoulsCubit({
    required SoulService soulService,
    required IsarService isarService,
  }) : super(const GetSoulsState.initial()) {
    _soulService = soulService;
    _isarService = isarService;
  }

  late SoulService _soulService;
  late IsarService _isarService;

  Future<void> getSouls({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetSoulsState.loading());
    try {
      if (!refresh) {
        await _isarService.souls.refreshParentStream(missionUlid);
        emit(const GetSoulsState.loaded());
        return;
      }

      final souls = await _soulService.list(
        filters: {
          'mission_ulid': missionUlid,
        },
        includes: ['classGroup', 'mission'],
      );
      await _isarService.souls.persistEntities(souls);
      await _isarService.souls.refreshParentStream(missionUlid);
      emit(const GetSoulsState.loaded());
    } on Failure catch (e) {
      emit(GetSoulsState.error(e.message));
    } catch (e) {
      emit(GetSoulsState.error(e.toString()));
    }
  }
}
