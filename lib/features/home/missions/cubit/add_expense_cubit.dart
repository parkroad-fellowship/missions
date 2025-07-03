import 'package:app/enums/prf_charge_type.dart';
import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/expense_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_expense_state.dart';
part 'add_expense_cubit.freezed.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit({
    required ExpenseService expenseService,
    required HiveService hiveService,
  }) : super(const AddExpenseState.initial()) {
    _expenseService = expenseService;
    _hiveService = hiveService;
  }

  late ExpenseService _expenseService;
  late HiveService _hiveService;

  Future<void> addExpense({
    required String missionUlid,
    required String expenseCategoryUlid,
    required String unitCost,
    required String quantity,
    required String charge,
    required PRFChargeType chargeType,
    required String confirmationMessage,
    required String narration,
  }) async {
    emit(const AddExpenseState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final missionExpense = _hiveService.data.expenses.retrieveMissionExpense(
        missionUlid,
      );
      if (missionExpense == null) {
        emit(const AddExpenseState.error('Please wait for funds to be issued'));
      }

      final expense = await _expenseService.create(
        data: PRFExpenseDTO(
          expenseableType: PRFMorphType.missionExpense.apiKey,
          expenseableUlid: missionExpense!.ulid,
          expenseCategoryUlid: expenseCategoryUlid,
          memberUlid: member.ulid,
          chargeType: chargeType.apiKey,
          confirmationMessage: confirmationMessage,
          unitCost: int.parse(unitCost),
          quantity: int.parse(quantity),
          charge: int.parse(charge),
          narration: narration,
        ).toJson(),
      );

      _hiveService.data.expenses.persistExpense(expense, missionUlid);

      emit(AddExpenseState.loaded(expense: expense));
    } on Failure catch (e) {
      emit(AddExpenseState.error(e.message));
    } catch (e) {
      emit(AddExpenseState.error(e.toString()));
    }
  }
}
