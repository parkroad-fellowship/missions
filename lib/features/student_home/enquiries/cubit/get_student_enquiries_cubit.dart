import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_student_enquiries_state.dart';
part 'get_student_enquiries_cubit.freezed.dart';

class GetStudentEnquiriesCubit extends Cubit<GetStudentEnquiriesState> {
  GetStudentEnquiriesCubit({
    required StudentService studentService,
    required HiveService hiveService,
  }) : super(const GetStudentEnquiriesState.initial()) {
    _studentService = studentService;
    _hiveService = hiveService;
  }

  late StudentService _studentService;
  late HiveService _hiveService;

  Future<void> getStudentEnquiries() async {
    emit(const GetStudentEnquiriesState.loading());
    try {
      final studentUlid = _hiveService.retrieveStudentUlid();
      final enquiries = await _studentService.getStudentEnquiries(
        studentUlid: studentUlid,
      );
      emit(GetStudentEnquiriesState.loaded(enquiries: enquiries));
    } catch (e) {
      emit(GetStudentEnquiriesState.error(e.toString()));
    }
  }
}
