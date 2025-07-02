import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/remote/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/student_enquiry_reply_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_student_enquiry_reply_state.dart';
part 'create_student_enquiry_reply_cubit.freezed.dart';

class CreateEnquiryReplyCubit extends Cubit<CreateEnquiryReplyState> {
  CreateEnquiryReplyCubit({
    required HiveService hiveService,
    required StudentEnquiryReplyService studentEnquiryService,
    required LocalDBService localDBService,
  }) : super(const CreateEnquiryReplyState.initial()) {
    _hiveService = hiveService;
    _studentEnquiryService = studentEnquiryService;
    _localDBService = localDBService;
  }

  late HiveService _hiveService;
  late StudentEnquiryReplyService _studentEnquiryService;
  late LocalDBService _localDBService;

  Future<void> createStudentEnquiryReply({
    required String content,
    required String studentEnquiryUlid,
  }) async {
    emit(const CreateEnquiryReplyState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final reply = await _studentEnquiryService.create(
        data: PRFStudentEnquiryReplyDTO(
          content: content,
          studentEnquiryUlid: studentEnquiryUlid,
          commentorableType: PRFMorphType.member,
          commentorableUlid: member.ulid,
        ).toJson(),
      );

      await _localDBService.persistStudentEnquiryReplies(
        studentEnquiryUlid: studentEnquiryUlid,
        replies: [reply],
      );

      emit(const CreateEnquiryReplyState.loaded());
    } catch (e) {
      emit(CreateEnquiryReplyState.error(e.toString()));
    }
  }
}
