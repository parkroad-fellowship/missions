import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMorphType {
  @JsonValue(1)
  member(1),
  @JsonValue(2)
  student(2),
  @JsonValue(3)
  missionExpense(3),
  @JsonValue(4)
  event(4),
  @JsonValue(5)
  mission(5),
  @JsonValue(6)
  chatBot(6),
  @JsonValue(7)
  school(7),
  @JsonValue(8)
  missionSession(8),
  @JsonValue(9)
  missionQuestion(9)
  ;

  const PRFMorphType(this.apiKey);

  final int apiKey;
}
