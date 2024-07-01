import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_student_enquiry_reply_state.dart';
part 'create_student_enquiry_reply_cubit.freezed.dart';

class CreateStudentEnquiryReplyCubit
    extends Cubit<CreateStudentEnquiryReplyState> {
  CreateStudentEnquiryReplyCubit({
    required HiveService hiveService,
    required StudentService studentService,
  }) : super(const CreateStudentEnquiryReplyState.initial()) {
    _hiveService = hiveService;
    _studentService = studentService;
  }

  late HiveService _hiveService;
  late StudentService _studentService;

  Future<void> createStudentEnquiryReply({
    required String content,
    required String studentEnquiryUlid,
  }) async {
    emit(const CreateStudentEnquiryReplyState.loading());
    try {
      final studentUlid = _hiveService.retrieveStudentUlid();
      await _studentService.createStudentEnquiryReply(
        studentEnquiryReplyDTO: PRFStudentEnquiryReplyDTO(
          content: content,
          studentEnquiryUlid: studentEnquiryUlid,
          commentorableType: PRFMorphType.student.apiKey,
          commentorableUlid: studentUlid,
        ),
      );

      emit(const CreateStudentEnquiryReplyState.loaded());
    } catch (e) {
      emit(CreateStudentEnquiryReplyState.error(e.toString()));
    }
  }
}
