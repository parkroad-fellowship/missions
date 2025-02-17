import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiry_replies_state.dart';
part 'get_student_enquiry_replies_cubit.freezed.dart';

class GetEnquiryRepliesCubit extends Cubit<GetEnquiryRepliesState> {
  GetEnquiryRepliesCubit({
    required StudentService studentService,
    required LocalDBService localDBService,
  }) : super(const GetEnquiryRepliesState.initial()) {
    _studentService = studentService;
    _localDBService = localDBService;
  }

  late StudentService _studentService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiryReplies({required String enquiryUlid}) async {
    emit(const GetEnquiryRepliesState.loading());
    try {
      final replies = await _studentService.getStudentEnquiryReplies(
        studentEnquiryUlid: enquiryUlid,
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
