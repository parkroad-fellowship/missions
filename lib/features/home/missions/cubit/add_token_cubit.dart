import 'package:app/models/remote/failure.dart';
import 'package:app/services/mission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_token_state.dart';
part 'add_token_cubit.freezed.dart';

class AddTokenCubit extends Cubit<AddTokenState> {
  AddTokenCubit({
    required MissionService missionService,
  }) : super(AddTokenState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> addToken({
    required String missionExpenseUlid,
    required String tokenAmount,
  }) async {
    emit(AddTokenState.loading());
    try {
      await _missionService.addToken(
        missionExpenseUlid: missionExpenseUlid,
        tokenAmount: int.parse(tokenAmount),
      );

      emit(AddTokenState.loaded());
    } on Failure catch(e) {
      emit(AddTokenState.error(e.message));
    }
     catch (e) {
      emit(AddTokenState.error(e.toString()));
    }
  }
}
