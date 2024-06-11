enum PRFMissionRole { member, leader, assistant }

extension PRFMissionRoleExtension on PRFMissionRole {
  String get name {
    switch (this) {
      case PRFMissionRole.member:
        return 'Member';
      case PRFMissionRole.leader:
        return 'Mission Leader';
      case PRFMissionRole.assistant:
        return 'Assistant Mission Leader';
    }
  }

  static PRFMissionRole fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFMissionRole.member;
      case 2:
        return PRFMissionRole.leader;
      case 3:
        return PRFMissionRole.assistant;
      default:
        return PRFMissionRole.member;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFMissionRole.member:
        return 1;
      case PRFMissionRole.leader:
        return 2;
      case PRFMissionRole.assistant:
        return 3;
    }
  }
}
