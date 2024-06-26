enum PRFEvent {
  courseMemberUpdated,
}

extension PRFEventExtension on PRFEvent {
  String get name {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 'Course Member Updated';
    }
  }

  static PRFEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFEvent.courseMemberUpdated;
      default:
        return PRFEvent.courseMemberUpdated;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 1;
    }
  }
}
