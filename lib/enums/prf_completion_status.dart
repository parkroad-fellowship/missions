enum PRFCompletionStatus { incomplete, complete }

extension PRFCompletionStatusExtension on PRFCompletionStatus {
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
}
