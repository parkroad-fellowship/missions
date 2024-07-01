import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_student_enquiry_reply_dto.freezed.dart';
part 'prf_student_enquiry_reply_dto.g.dart';

@freezed
class PRFStudentEnquiryReplyDTO with _$PRFStudentEnquiryReplyDTO {
  factory PRFStudentEnquiryReplyDTO({
    @JsonKey(name: 'student_enquiry_ulid') required String studentEnquiryUlid,
    required String content,
    @JsonKey(name: 'commentorable_ulid') required String commentorableUlid,
    @JsonKey(name: 'commentorable_type') required int commentorableType,
  }) = _PRFStudentEnquiryReplyDTO;

  factory PRFStudentEnquiryReplyDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFStudentEnquiryReplyDTOFromJson(json);
}
