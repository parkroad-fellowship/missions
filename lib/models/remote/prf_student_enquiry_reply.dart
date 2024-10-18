import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_student_enquiry_reply.freezed.dart';
part 'prf_student_enquiry_reply.g.dart';

@freezed
class PRFStudentEnquiryReply with _$PRFStudentEnquiryReply {
  factory PRFStudentEnquiryReply(
    String ulid,
    String content,
    @JsonKey(name: 'commentorable_type') PRFMorphType commentorableType,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'student_enquiry') PRFStudentEnquiry? studentEnquiry,
  }) = _PRFStudentEnquiryReply;

  factory PRFStudentEnquiryReply.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryReplyFromJson(json);
}

@freezed
class PRFStudentEnquiryReplyResponse with _$PRFStudentEnquiryReplyResponse {
  const factory PRFStudentEnquiryReplyResponse({
    required List<PRFStudentEnquiryReply> data,
  }) = _PRFStudentEnquiryReplyResponse;

  factory PRFStudentEnquiryReplyResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryReplyResponseFromJson(json);
}
