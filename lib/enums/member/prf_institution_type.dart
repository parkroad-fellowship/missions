import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFInstitutionType {
  @JsonValue(1)
  highSchool('High School', 1),
  @JsonValue(2)
  primarySchool('Primary School', 2),
  @JsonValue(3)
  college('College', 3),
  @JsonValue(4)
  university('University', 4),
  @JsonValue(5)
  community('Community', 5),
  @JsonValue(6)
  juniorSecondarySchool('Junior Secondary School', 6),
  @JsonValue(7)
  seniorSecondarySchool('Senior Secondary School', 7);

  const PRFInstitutionType(this.label, this.value);

  final String label;
  final int value;

  static PRFInstitutionType fromValue(int value) {
    switch (value) {
      case 1:
        return PRFInstitutionType.highSchool;
      case 2:
        return PRFInstitutionType.primarySchool;
      case 3:
        return PRFInstitutionType.college;
      case 4:
        return PRFInstitutionType.university;
      case 5:
        return PRFInstitutionType.community;
      case 6:
        return PRFInstitutionType.juniorSecondarySchool;
      default:
        return PRFInstitutionType.highSchool;
    }
  }
}
