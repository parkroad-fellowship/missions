import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFChargeType {
  @JsonValue(1)
  mpesaDefault(1, '(MPESA) User/Till/Paybill'),
  @JsonValue(2)
  mpesaOtherRegisteredUser(2, '(MPESA) Other Registered User'),
  @JsonValue(3)
  mpesaAgentWithdrawal(3, '(MPESA) Agent Withdrawal'),
  @JsonValue(4)
  mpesaATMWithdrawal(4, '(MPESA) ATM Withdrawal'),
  @JsonValue(5)
  cash(5, 'Cash')
  ;

  const PRFChargeType(this.apiKey, this.name);

  final int apiKey;
  final String name;
}
