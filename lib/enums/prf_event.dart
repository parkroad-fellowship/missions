enum PRFEvent {
  courseMemberUpdated,
  memberModuleUpdated,
}

extension PRFEventExtension on PRFEvent {
  String get name {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 'Course Member Updated';
      case PRFEvent.memberModuleUpdated:
        return 'Member Module Updated';
    }
  }

  static PRFEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFEvent.courseMemberUpdated;
      case 2:
        return PRFEvent.memberModuleUpdated;
      default:
        return PRFEvent.courseMemberUpdated;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 1;
      case PRFEvent.memberModuleUpdated:
        return 2;
    }
  }
}
