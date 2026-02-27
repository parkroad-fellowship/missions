import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiry_state.dart';
part 'get_student_enquiry_cubit.freezed.dart';

class GetStudentEnquiryCubit extends Cubit<GetStudentEnquiryState> {
  GetStudentEnquiryCubit({
    required StudentEnquiryService studentEnquiryService,
    required IsarService isarService,
  }) : super(const GetStudentEnquiryState.initial()) {
    _studentEnquiryService = studentEnquiryService;
    _isarService = isarService;
  }

  late IsarService _isarService;
  late StudentEnquiryService _studentEnquiryService;

  Future<void> getStudentEnquiry({
    required String studentEnquiryUlid,
  }) async {
    emit(const GetStudentEnquiryState.loading());
    try {
      final localEnquiry = await _isarService.studentEnquiries.get(
        studentEnquiryUlid,
      );
      if (localEnquiry == null) {
        final enquiry = await _studentEnquiryService.get(
          ulid: studentEnquiryUlid,
        );
        await _isarService.studentEnquiries.persistEntity(enquiry);
      }

      await _isarService.studentEnquiries.refreshItemStream(studentEnquiryUlid);
      emit(const GetStudentEnquiryState.loaded());
    } on Failure catch (e) {
      emit(GetStudentEnquiryState.error(e.message));
    } catch (e) {
      emit(GetStudentEnquiryState.error(e.toString()));
    }
  }
}
