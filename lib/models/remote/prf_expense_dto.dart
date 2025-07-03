import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_expense_dto.freezed.dart';
part 'prf_expense_dto.g.dart';

@freezed
abstract class PRFExpenseDTO with _$PRFExpenseDTO {
  factory PRFExpenseDTO({
    @JsonKey(name: 'expense_category_ulid') required String expenseCategoryUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    @JsonKey(name: 'charge_type') required int chargeType,
    @JsonKey(name: 'expenseable_ulid') required String expenseableUlid,
    @JsonKey(name: 'expenseable_type') required int expenseableType,
    @JsonKey(name: 'confirmation_message') required String confirmationMessage,
    @JsonKey(name: 'unit_cost') required int unitCost,
    required int quantity,
    required int charge,
    required String narration,
  }) = _PRFExpenseDTO;

  factory PRFExpenseDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFExpenseDTOFromJson(json);
}
