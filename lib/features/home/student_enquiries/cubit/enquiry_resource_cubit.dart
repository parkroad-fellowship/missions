import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EnquiryResourceCubit extends ResourceCubit<PRFStudentEnquiry> {
  EnquiryResourceCubit({
    required StudentEnquiryService studentEnquiryService,
    required HiveService hiveService,
  }) : super(
         service: studentEnquiryService,
         dbService: hiveService.studentEnquiries,
       );

  @override
  Future<List<PRFStudentEnquiry>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
