import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMissionRole {
  @JsonValue(1)
  member('Member'),
  @JsonValue(2)
  leader('Mission Leader'),
  @JsonValue(3)
  assistant('Assistant Mission Leader'),
  @JsonValue(4)
  discipleshipTrainer('Discipleship Trainer'),
  @JsonValue(5)
  musicInstruments('Music Instruments'),
  @JsonValue(6)
  transportation('Transportation')
  ;

  const PRFMissionRole(this.name);
  final String name;
}
