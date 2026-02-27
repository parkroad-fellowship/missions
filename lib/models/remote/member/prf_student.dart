import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_student.freezed.dart';
part 'prf_student.g.dart';

@freezed
abstract class PRFStudent with _$PRFStudent {
  factory PRFStudent(
    String ulid,
    String name,
    String email,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _PRFStudent;

  factory PRFStudent.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentFromJson(json);
}
