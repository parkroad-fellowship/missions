import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_student_enquiry_dto.freezed.dart';
part 'prf_student_enquiry_dto.g.dart';

@freezed
abstract class PRFStudentEnquiryDTO with _$PRFStudentEnquiryDTO {
  factory PRFStudentEnquiryDTO({
    @JsonKey(name: 'student_ulid') required String studentUlid,
    required String content,
  }) = _PRFStudentEnquiryDTO;

  factory PRFStudentEnquiryDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryDTOFromJson(json);
}
