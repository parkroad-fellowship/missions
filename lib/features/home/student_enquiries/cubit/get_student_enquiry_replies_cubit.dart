import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiry_replies_state.dart';
part 'get_student_enquiry_replies_cubit.freezed.dart';

class GetEnquiryRepliesCubit extends Cubit<GetEnquiryRepliesState> {
  GetEnquiryRepliesCubit({
    required StudentEnquiryReplyService studentEnquiryService,
    required IsarService isarService,
  }) : super(const GetEnquiryRepliesState.initial()) {
    _studentEnquiryService = studentEnquiryService;
    _isarService = isarService;
  }

  late StudentEnquiryReplyService _studentEnquiryService;
  late IsarService _isarService;

  Future<void> getStudentEnquiryReplies({required String enquiryUlid}) async {
    emit(const GetEnquiryRepliesState.loading());
    try {
      final replies = await _studentEnquiryService.list(
        filters: {
          'student_enquiry_ulid': enquiryUlid,
        },
      );
      if (replies.isNotEmpty) {
        await _isarService.studentEnquiryReplies.persistEntities(
          replies,
        );
      }

      emit(const GetEnquiryRepliesState.loaded());
    } catch (e) {
      emit(GetEnquiryRepliesState.error(e.toString()));
    }
  }
}
