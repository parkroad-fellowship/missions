import 'package:app/models/remote/prf_student_enquiry_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_enquiry_state.dart';
part 'create_enquiry_cubit.freezed.dart';

class CreateEnquiryCubit extends Cubit<CreateEnquiryState> {
  CreateEnquiryCubit({
    required HiveService hiveService,
    required StudentService studentService,
  }) : super(const CreateEnquiryState.initial()) {
    _hiveService = hiveService;
    _studentService = studentService;
  }

  late HiveService _hiveService;
  late StudentService _studentService;

  Future<void> createEnquiry({
    required String content,
  }) async {
    emit(const CreateEnquiryState.loading());
    try {
      final studentUlid = _hiveService.retrieveStudentUlid();

      await _studentService.createStudentEnquiry(
        studentEnquiryDTO: PRFStudentEnquiryDTO(
          studentUlid: studentUlid,
          content: content,
        ),
      );

      emit(const CreateEnquiryState.loaded());
    } catch (e) {
      emit(CreateEnquiryState.error(e.toString()));
    }
  }
}
