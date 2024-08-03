import 'package:flutter/material.dart';

enum PRFCompletionStatus {
  incomplete,
  complete;

  String get name {
    switch (this) {
      case PRFCompletionStatus.incomplete:
        return 'Incomplete';
      case PRFCompletionStatus.complete:
        return 'Complete';
    }
  }

  static PRFCompletionStatus fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFCompletionStatus.incomplete;
      case 2:
        return PRFCompletionStatus.complete;
      default:
        return PRFCompletionStatus.incomplete;
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

  IconData get icon {
    switch (this) {
      case PRFCompletionStatus.incomplete:
        return Icons.check;
      case PRFCompletionStatus.complete:
        return Icons.watch_later_outlined;
    }
  }
}
