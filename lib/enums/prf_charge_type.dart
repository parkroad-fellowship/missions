import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFChargeType {
  @JsonValue(1)
  primary,
  @JsonValue(2)
  otherRegisteredUser,
  @JsonValue(3)
  agentWithdrawal,
  @JsonValue(4)
  atmWithdrawal,
  @JsonValue(5)
  cash;

  String get name {
    switch (this) {
      case PRFChargeType.primary:
        return 'MPESA User/Till/Paybill';
      case PRFChargeType.otherRegisteredUser:
        return 'Other Registered User';
      case PRFChargeType.agentWithdrawal:
        return 'Agent Withdrawal';
      case PRFChargeType.atmWithdrawal:
        return 'ATM Withdrawal';
      case PRFChargeType.cash:
        return 'Cash';
    }
  }

  int get apiKey {
    switch (this) {
      case PRFChargeType.primary:
        return 1;
      case PRFChargeType.otherRegisteredUser:
        return 2;
      case PRFChargeType.agentWithdrawal:
        return 3;
      case PRFChargeType.atmWithdrawal:
        return 4;
      case PRFChargeType.cash:
        return 5;
    }
  }
}
