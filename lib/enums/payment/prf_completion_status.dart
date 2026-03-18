import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFCompletionStatus {
  @JsonValue(1)
  incomplete,
  @JsonValue(2)
  complete
  ;

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
        return Icons.watch_later_outlined;
      case PRFCompletionStatus.complete:
        return Icons.check;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFCompletionStatus.incomplete:
        return 1;
      case PRFCompletionStatus.complete:
        return 2;
    }
  }
}
