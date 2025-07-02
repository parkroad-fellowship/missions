import 'package:app/services/_index.dart';
import 'package:app/services/student_enquiry_reply_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiry_replies_state.dart';
part 'get_student_enquiry_replies_cubit.freezed.dart';

class GetEnquiryRepliesCubit extends Cubit<GetEnquiryRepliesState> {
  GetEnquiryRepliesCubit({
    required StudentEnquiryReplyService studentEnquiryService,
    required LocalDBService localDBService,
  }) : super(const GetEnquiryRepliesState.initial()) {
    _studentEnquiryService = studentEnquiryService;
    _localDBService = localDBService;
  }

  late StudentEnquiryReplyService _studentEnquiryService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiryReplies({required String enquiryUlid}) async {
    emit(const GetEnquiryRepliesState.loading());
    try {
      final replies = await _studentEnquiryService.list(
        filters: {
          'filter[student_enquiry_ulid]': enquiryUlid,
        }
      );

      await _localDBService.persistStudentEnquiryReplies(
        studentEnquiryUlid: enquiryUlid,
        replies: replies,
      );
      emit(const GetEnquiryRepliesState.loaded());
    } catch (e) {
      emit(GetEnquiryRepliesState.error(e.toString()));
    }
  }
}
