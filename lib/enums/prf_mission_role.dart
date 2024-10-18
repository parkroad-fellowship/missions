import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMissionRole {
  @JsonValue(1)
  member,
  @JsonValue(2)
  leader,
  @JsonValue(3)
  assistant,
  @JsonValue(4)
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
}
