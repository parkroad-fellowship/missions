enum PRFEvent {
  courseMemberUpdated,
  memberModuleUpdated,
  lessonMemberUpdated,
}

extension PRFEventExtension on PRFEvent {
  String get name {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 'Course Member Updated';
      case PRFEvent.memberModuleUpdated:
        return 'Member Module Updated';
      case PRFEvent.lessonMemberUpdated:
        return 'Lesson Member Updated';
    }
  }

  static PRFEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFEvent.courseMemberUpdated;
      case 2:
        return PRFEvent.memberModuleUpdated;
      case 3:
        return PRFEvent.lessonMemberUpdated;
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
      case PRFEvent.lessonMemberUpdated:
        return 3;
    }
  }
}
