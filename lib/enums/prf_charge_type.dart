import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFChargeType {
  @JsonValue(1)
  primary,
  @JsonValue(2)
  otherRegisteredUser,
  @JsonValue(3)
  agentWithdrawal,
  @JsonValue(4)
  atmWithdrawal;

  String get name {
    switch (this) {
      case PRFChargeType.primary:
        return 'Default';
      case PRFChargeType.otherRegisteredUser:
        return 'Other Registered User';
      case PRFChargeType.agentWithdrawal:
        return 'Agent Withdrawal';
      case PRFChargeType.atmWithdrawal:
        return 'ATM Withdrawal';
    }
  }
}
