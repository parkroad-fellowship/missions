import 'package:app/models/prf_soul.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_souls_state.dart';
part 'get_souls_cubit.freezed.dart';

class GetSoulsCubit extends Cubit<GetSoulsState> {
  GetSoulsCubit({
    required SoulService soulService,
    required HiveService hiveService,
  }) : super(const GetSoulsState.initial()) {
    _soulService = soulService;
    _hiveService = hiveService;
  }

  late SoulService _soulService;
  late HiveService _hiveService;

  Future<void> getSouls({
    required String missionUlid,
  }) async {
    emit(const GetSoulsState.loading());
    try {
      final localSouls = _hiveService.retrieveSouls(missionUlid);
      if (localSouls.isNotEmpty) {
        emit(GetSoulsState.loaded(souls: localSouls.reversed.toList()));
      }

      final souls = await _soulService.getSouls(missionUlid: missionUlid);
      _hiveService.persistSouls(PRFSoulResponse(data: souls), missionUlid);
    } catch (e) {
      emit(GetSoulsState.error(e.toString()));
    }
  }
}
