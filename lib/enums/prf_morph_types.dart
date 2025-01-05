import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMorphType {
  @JsonValue(1)
  member,
  @JsonValue(2)
  student,
  @JsonValue(3)
  missionExpense;
}
