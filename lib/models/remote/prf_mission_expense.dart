import 'package:app/models/remote/prf_expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_expense.freezed.dart';
part 'prf_mission_expense.g.dart';

@freezed
class PRFMissionExpense with _$PRFMissionExpense {
  factory PRFMissionExpense(
    String ulid,
    @JsonKey(name: 'amount_received') int amountReceived,
    @JsonKey(name: 'amount_spent') int amountSpent,
    @JsonKey(name: 'balance') int balance,
    @JsonKey(name: 'token_amount') int tokenAmount,
    @JsonKey(name: 'amount_to_refund') int amountToRefund,
    @JsonKey(name: 'amount_refunded') int amountRefunded,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'is_refunded') required bool isRefunded,
    @Default([]) List<PRFExpense> expenses,
  }) = _PRFMissionExpense;

  factory PRFMissionExpense.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionExpenseFromJson(json);
}
