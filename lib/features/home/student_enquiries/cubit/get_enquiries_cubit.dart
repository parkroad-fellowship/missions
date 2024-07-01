import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_enquiries_state.dart';
part 'get_enquiries_cubit.freezed.dart';

class GetEnquiriesCubit extends Cubit<GetEnquiriesState> {
  GetEnquiriesCubit({
    required StudentService studentService,
    required LocalDBService localDBService,
  }) : super(const GetEnquiriesState.initial()) {
    _studentService = studentService;
    _localDBService = localDBService;
  }

  late StudentService _studentService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiries() async {
    emit(const GetEnquiriesState.loading());
    try {
      final enquiries = await _studentService.getStudentEnquiries();

      await _localDBService.persistStudentEnquiries(enquiries: enquiries);
      emit(const GetEnquiriesState.loaded());
    } catch (e) {
      emit(GetEnquiriesState.error(e.toString()));
    }
  }
}
