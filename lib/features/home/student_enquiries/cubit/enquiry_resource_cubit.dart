import 'package:app/models/local/enquiry/prf_student_enquiry.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EnquiryResourceCubit
    extends ResourceCubit<PRFStudentEnquiry, PRFLocalStudentEnquiry> {
  EnquiryResourceCubit({
    required StudentEnquiryService studentEnquiryService,
    super.dbService,
  }) : super(service: studentEnquiryService);

  @override
  int? get defaultLimit => 100;
}
