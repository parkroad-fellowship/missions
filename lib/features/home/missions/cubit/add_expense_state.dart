part of 'add_expense_cubit.dart';

@freezed
class AddExpenseState with _$AddExpenseState {
  const factory AddExpenseState.initial() = _Initial;
  const factory AddExpenseState.loading() = _Loading;
  const factory AddExpenseState.loaded({
    required PRFExpense expense,
  }) = _Loaded;
  const factory AddExpenseState.error(String message) = _Error;
}
