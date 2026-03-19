import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/local_storage/_index.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EnquiryReplyResourceCubit extends ResourceCubit<PRFStudentEnquiryReply> {
  EnquiryReplyResourceCubit({
    required StudentEnquiryReplyService studentEnquiryReplyService,
    required HiveService hiveService,
    super.dbService,
  }) : _hiveService = hiveService,
       super(service: studentEnquiryReplyService) {
    subscribeToIsarUpdates();
  }

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => ['studentEnquiry'];

  @override
  int? get defaultLimit => 1000;

  /// Create a reply.
  Future<void> createReply({
    required String studentEnquiryUlid,
    required String content,
  }) async {
    final member = _hiveService.retrieveMember()!;
    final dto = PRFStudentEnquiryReplyDTO(
      studentEnquiryUlid: studentEnquiryUlid,
      content: content,
      commentorableUlid: member.ulid,
      commentorableType: PRFMorphType.member,
    );
    await create(data: dto.toJson());
  }
}
