import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EnquiryReplyResourceCubit extends ResourceCubit<PRFStudentEnquiryReply> {
  EnquiryReplyResourceCubit({
    required StudentEnquiryReplyService studentEnquiryReplyService,
    super.dbService,
  }) : super(service: studentEnquiryReplyService) {
    subscribeToIsarUpdates();
  }

  @override
  List<String> get defaultIncludes => ['studentEnquiry'];

  @override
  int? get defaultLimit => 1000;

  /// Create a reply.
  Future<void> createReply({required Map<String, dynamic> data}) async {
    await create(data: data);
  }
}
