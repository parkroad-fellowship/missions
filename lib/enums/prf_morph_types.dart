import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMorphType {
  @JsonValue(1)
  member,
  @JsonValue(2)
  student,
  @JsonValue(3)
  missionExpense;

  int get apiKey {
    switch (this) {
      case PRFMorphType.member:
        return 1;
      case PRFMorphType.student:
        return 2;
      case PRFMorphType.missionExpense:
        return 3;
    }
  }
}
