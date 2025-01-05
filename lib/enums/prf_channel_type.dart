import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFChannelType {
  @JsonValue(1)
  mPesa;

  String get name {
    switch (this) {
      case PRFChannelType.mPesa:
        return 'M-Pesa';
    }
  }
}
