import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_student_enquiry_reply_state.dart';
part 'create_student_enquiry_reply_cubit.freezed.dart';

class CreateEnquiryReplyCubit extends Cubit<CreateEnquiryReplyState> {
  CreateEnquiryReplyCubit({
    required HiveService hiveService,
    required StudentEnquiryReplyService studentEnquiryService,
    required IsarService isarService,
  }) : super(const CreateEnquiryReplyState.initial()) {
    _hiveService = hiveService;
    _studentEnquiryService = studentEnquiryService;
    _isarService = isarService;
  }

  late HiveService _hiveService;
  late StudentEnquiryReplyService _studentEnquiryService;
  late IsarService _isarService;

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
        includes: ['studentEnquiry'],
      );

      await _isarService.studentEnquiryReplies.persistEntity(reply);
      await _isarService.studentEnquiryReplies.refreshParentStream(
        studentEnquiryUlid,
      );

      emit(const CreateEnquiryReplyState.loaded());
    } catch (e) {
      emit(CreateEnquiryReplyState.error(e.toString()));
    }
  }
}
