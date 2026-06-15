import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply_dto.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EnquiryReplyResourceCubit extends ResourceCubit<PRFStudentEnquiryReply> {
  EnquiryReplyResourceCubit({
    required StudentEnquiryReplyService studentEnquiryReplyService,
    required HiveService hiveService,
  }) : _hiveService = hiveService,
       super(
         service: studentEnquiryReplyService,
         dbService: hiveService.studentEnquiryReplies,
       );

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => ['studentEnquiry'];

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

  @override
  Future<List<PRFStudentEnquiryReply>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
