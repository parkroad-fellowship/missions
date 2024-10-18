import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_student_enquiry_reply_state.dart';
part 'create_student_enquiry_reply_cubit.freezed.dart';

class CreateEnquiryReplyCubit extends Cubit<CreateEnquiryReplyState> {
  CreateEnquiryReplyCubit({
    required HiveService hiveService,
    required StudentService studentService,
  }) : super(const CreateEnquiryReplyState.initial()) {
    _hiveService = hiveService;
    _studentService = studentService;
  }

  late HiveService _hiveService;
  late StudentService _studentService;

  Future<void> createStudentEnquiryReply({
    required String content,
    required String studentEnquiryUlid,
  }) async {
    emit(const CreateEnquiryReplyState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      await _studentService.createStudentEnquiryReply(
        studentEnquiryReplyDTO: PRFStudentEnquiryReplyDTO(
          content: content,
          studentEnquiryUlid: studentEnquiryUlid,
          commentorableType: PRFMorphType.member,
          commentorableUlid: member.ulid,
        ),
      );

      emit(const CreateEnquiryReplyState.loaded());
    } catch (e) {
      emit(CreateEnquiryReplyState.error(e.toString()));
    }
  }
}
