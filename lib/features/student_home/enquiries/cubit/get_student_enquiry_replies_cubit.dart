import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiry_replies_state.dart';
part 'get_student_enquiry_replies_cubit.freezed.dart';

class GetStudentEnquiryRepliesCubit
    extends Cubit<GetStudentEnquiryRepliesState> {
  GetStudentEnquiryRepliesCubit({
    required StudentService studentService,
    required LocalDBService localDBService,
  }) : super(const GetStudentEnquiryRepliesState.initial()) {
    _studentService = studentService;
    _localDBService = localDBService;
  }

  late StudentService _studentService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiryReplies({required String enquiryUlid}) async {
    emit(const GetStudentEnquiryRepliesState.loading());
    try {
      final replies = await _studentService.getStudentEnquiryReplies(
        studentEnquiryUlid: enquiryUlid,
      );

      await _localDBService.persistStudentEnquiryReplies(
        studentEnquiryUlid: enquiryUlid,
        replies: replies,
      );
      emit(const GetStudentEnquiryRepliesState.loaded());
    } catch (e) {
      emit(GetStudentEnquiryRepliesState.error(e.toString()));
    }
  }
}
