import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


enum PRFCompletionStatus {
  @JsonValue(1)
  incomplete,

  @JsonValue(2)
  complete;

  String get name {
    switch (this) {
      case PRFCompletionStatus.incomplete:
        return 'Incomplete';
      case PRFCompletionStatus.complete:
        return 'Complete';
    }
  }

  IconData get icon {
    switch (this) {
      case PRFCompletionStatus.incomplete:
        return Icons.check;
      case PRFCompletionStatus.complete:
        return Icons.watch_later_outlined;
    }
  }
}
