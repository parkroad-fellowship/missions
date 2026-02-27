import 'dart:async';

import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/models/local/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class StudentEnquiryReplyDbService
    extends
        BaseLocalDBService<
          PRFStudentEnquiryReply,
          PRFLocalStudentEnquiryReply
        > {
  StudentEnquiryReplyDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalStudentEnquiryReply> get collection =>
      dbInstance.pRFLocalStudentEnquiryReplys;

  @override
  PRFLocalStudentEnquiryReply remoteToLocal(PRFStudentEnquiryReply remote) {
    return PRFLocalStudentEnquiryReply(
      ulid: remote.ulid,
      studentEnquiryUlid: remote.studentEnquiry!.ulid,
      content: remote.content,
      createdAt: remote.createdAt,
      commentorableType: remote.commentorableType,
      isStudent: remote.commentorableType == PRFMorphType.student,
    );
  }

  Future<List<PRFLocalStudentEnquiryReply>> listParentStudentEnquiryReplies(
    String parentKey,
  ) async {
    return collection
        .where()
        .studentEnquiryUlidEqualTo(parentKey)
        .sortByCreatedAt()
        .findAll();
  }

  StreamController<List<PRFLocalStudentEnquiryReply>>? _parentStreamController;
  Stream<List<PRFLocalStudentEnquiryReply>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalStudentEnquiryReply>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalStudentEnquiryReply>>.broadcast();
    final entities = await listParentStudentEnquiryReplies(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
