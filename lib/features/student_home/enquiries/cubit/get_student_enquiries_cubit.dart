import 'dart:ffi';

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
    required LocalDBService localDBService,
  }) : super(const GetStudentEnquiriesState.initial()) {
    _studentService = studentService;
    _hiveService = hiveService;
    _localDBService = localDBService;
  }

  late StudentService _studentService;
  late HiveService _hiveService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiries() async {
    emit(const GetStudentEnquiriesState.loading());
    try {
      final studentUlid = _hiveService.retrieveStudentUlid();
      final enquiries = await _studentService.getStudentEnquiries(
        studentUlid: studentUlid,
      );

      await _localDBService.persistStudentEnquiries(enquiries: enquiries);
      emit(const GetStudentEnquiriesState.loaded());
    } catch (e) {
      emit(GetStudentEnquiriesState.error(e.toString()));
    }
  }
}
