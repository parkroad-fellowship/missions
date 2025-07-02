import 'package:app/services/_index.dart';
import 'package:app/services/student_enquiry_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_enquiries_state.dart';
part 'get_enquiries_cubit.freezed.dart';

class GetEnquiriesCubit extends Cubit<GetEnquiriesState> {
  GetEnquiriesCubit({
    required StudentEnquiryService studentEnquiryService,
    required LocalDBService localDBService,
  }) : super(const GetEnquiriesState.initial()) {
    _studentEnquiryService = studentEnquiryService;
    _localDBService = localDBService;
  }

  late StudentEnquiryService _studentEnquiryService;
  late LocalDBService _localDBService;

  Future<void> getStudentEnquiries() async {
    emit(const GetEnquiriesState.loading());
    try {
      final enquiries = await _studentEnquiryService.list();

      await _localDBService.persistStudentEnquiries(enquiries: enquiries);
      emit(const GetEnquiriesState.loaded());
    } catch (e) {
      emit(GetEnquiriesState.error(e.toString()));
    }
  }
}
