enum PRFMorphType {
  member,
  student;

  static PRFMorphType fromAPIKey(int apiKey) {
    switch (apiKey) {
      case 1:
        return PRFMorphType.member;
      case 2:
        return PRFMorphType.student;
      default:
        return PRFMorphType.member;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFMorphType.member:
        return 1;
      case PRFMorphType.student:
        return 2;
    }
  }
}
