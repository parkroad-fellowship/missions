import 'package:app/models/prf_soul.dart';
import 'package:app/services/soul_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_souls_state.dart';
part 'get_souls_cubit.freezed.dart';

class GetSoulsCubit extends Cubit<GetSoulsState> {
  GetSoulsCubit({
    required SoulService soulService,
  }) : super(const GetSoulsState.initial()) {
    _soulService = soulService;
  }

  late SoulService _soulService;

  Future<void> getSouls({
    required String missionUlid,
  }) async {
    emit(const GetSoulsState.loading());
    try {
      final souls = await _soulService.getSouls(missionUlid: missionUlid);
      emit(
        GetSoulsState.loaded(
          souls: souls,
        ),
      );
    } catch (e) {
      emit(GetSoulsState.error(e.toString()));
    }
  }
}
