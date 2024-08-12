enum PRFMissionRole {
  member,
  leader,
  assistant,
  discipleshipTrainer;

  String get name {
    switch (this) {
      case PRFMissionRole.member:
        return 'Member';
      case PRFMissionRole.leader:
        return 'Mission Leader';
      case PRFMissionRole.assistant:
        return 'Assistant Mission Leader';
      case PRFMissionRole.discipleshipTrainer:
        return 'Discipleship Trainer';
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
      case 4:
        return PRFMissionRole.discipleshipTrainer;
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
      case PRFMissionRole.discipleshipTrainer:
        return 4;
    }
  }
}
