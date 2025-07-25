import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_enquiries_state.dart';
part 'get_enquiries_cubit.freezed.dart';

class GetEnquiriesCubit extends Cubit<GetEnquiriesState> {
  GetEnquiriesCubit({
    required StudentEnquiryService studentEnquiryService,
    required IsarService isarService,
  }) : super(const GetEnquiriesState.initial()) {
    _studentEnquiryService = studentEnquiryService;
    _isarService = isarService;
  }

  late StudentEnquiryService _studentEnquiryService;
  late IsarService _isarService;

  Future<void> getStudentEnquiries() async {
    emit(const GetEnquiriesState.loading());
    try {
      final enquiries = await _studentEnquiryService.list(limit: 100);

      await _isarService.studentEnquiries.persistEntities(enquiries);
      emit(const GetEnquiriesState.loaded());
    } catch (e) {
      emit(GetEnquiriesState.error(e.toString()));
    }
  }
}
