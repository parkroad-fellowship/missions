import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_expense_state.dart';
part 'get_mission_expense_cubit.freezed.dart';

class GetMissionExpenseCubit extends Cubit<GetMissionExpenseState> {
  GetMissionExpenseCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(GetMissionExpenseState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> getMissionExpense({
    required String missionUlid,
  }) async {
    emit(const GetMissionExpenseState.loading());
    try {
      final missionExpense = await _missionService.getMissionExpense(
        missionUlid: missionUlid,
      );

      _hiveService.persistMissionExpense(missionExpense, missionUlid);

      emit(GetMissionExpenseState.loaded(missionExpense: missionExpense));
    } on Failure catch (e) {
      if (e.statusCode == 404) {
        emit(const GetMissionExpenseState.empty());
        return;
      }
      emit(GetMissionExpenseState.error(message: e.message));
    } catch (e) {
      emit(GetMissionExpenseState.error(message: e.toString()));
    }
  }
}
