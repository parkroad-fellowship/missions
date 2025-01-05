import 'package:app/enums/prf_channel_type.dart';
import 'package:app/enums/prf_charge_type.dart';
import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_expense.freezed.dart';
part 'prf_expense.g.dart';

@freezed
class PRFExpense with _$PRFExpense {
  factory PRFExpense(
    String ulid,
    @JsonEnum() @JsonKey(name: 'expenseable_type') PRFMorphType expenseableType,
    @JsonEnum() @JsonKey(name: 'channel_type') PRFChannelType channelType,
    @JsonEnum() @JsonKey(name: 'charge_type') PRFChargeType chargeType,
    int amout,
    int charge,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'confirmation_message') String? confirmationMessage,
    @JsonKey(name: 'expense_category') PRFExpenseCategory? expenseCategory,
    PRFMember? member,
  }) = _PRFExpense;

  factory PRFExpense.fromJson(Map<String, dynamic> json) =>
      _$PRFExpenseFromJson(json);
}
