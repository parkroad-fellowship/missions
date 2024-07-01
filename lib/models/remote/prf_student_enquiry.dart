import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_student_enquiry.freezed.dart';
part 'prf_student_enquiry.g.dart';

@freezed
class PRFStudentEnquiry with _$PRFStudentEnquiry {
  factory PRFStudentEnquiry(
    String ulid,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _PRFStudentEnquiry;

  factory PRFStudentEnquiry.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryFromJson(json);
}

@freezed
class PRFStudentEnquiryResponse with _$PRFStudentEnquiryResponse {
  const factory PRFStudentEnquiryResponse({
    required List<PRFStudentEnquiry> data,
  }) = _PRFStudentEnquiryResponse;

  factory PRFStudentEnquiryResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryResponseFromJson(json);
}
