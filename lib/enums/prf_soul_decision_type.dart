import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFSoulDecisionType {
  @JsonValue(1)
  salvation,
  @JsonValue(2)
  rededication,
  @JsonValue(3)
  other;

  String get name {
    switch (this) {
      case PRFSoulDecisionType.salvation:
        return 'Salvation';
      case PRFSoulDecisionType.rededication:
        return 'Rededication';
      case PRFSoulDecisionType.other:
        return 'Other';
    }
  }

  int get apiKey {
    switch (this) {
      case PRFSoulDecisionType.salvation:
        return 1;
      case PRFSoulDecisionType.rededication:
        return 2;
      case PRFSoulDecisionType.other:
        return 3;
    }
  }
}
