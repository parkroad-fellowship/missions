import 'package:app/models/remote/failure.dart';
import 'package:app/services/api/mission_expenses_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_token_state.dart';
part 'add_token_cubit.freezed.dart';

class AddTokenCubit extends Cubit<AddTokenState> {
  AddTokenCubit({required MissionExpensesService missionExpensesService})
    : super(const AddTokenState.initial()) {
    _missionExpensesService = missionExpensesService;
  }

  late MissionExpensesService _missionExpensesService;

  Future<void> addToken({
    required String missionExpenseUlid,
    required String tokenAmount,
  }) async {
    emit(const AddTokenState.loading());
    try {
      await _missionExpensesService.update(
        id: missionExpenseUlid,
        data: {'token_amount': int.parse(tokenAmount)},
      );

      emit(const AddTokenState.loaded());
    } on Failure catch (e) {
      emit(AddTokenState.error(e.message));
    } catch (e) {
      emit(AddTokenState.error(e.toString()));
    }
  }
}
