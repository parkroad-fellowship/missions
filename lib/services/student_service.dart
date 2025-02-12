import 'dart:convert';

import 'package:app/models/remote/prf_faq.dart';
import 'package:app/models/remote/prf_faq_category.dart';
import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:app/models/remote/prf_student_enquiry_dto.dart';
import 'package:app/models/remote/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/prf_student_enquiry_reply_dto.dart';
import 'package:app/utils/_index.dart';

abstract class StudentService {
  Future<List<PRFFaq>> getFaqs({
    String? include,
  });
  Future<List<PRFFaqCategory>> getFaqCategories();
  Future<List<PRFStudentEnquiry>> getStudentEnquiries({
    String? studentUlid,
  });
  Future<PRFStudentEnquiry> createStudentEnquiry({
    required PRFStudentEnquiryDTO studentEnquiryDTO,
  });
  Future<List<PRFStudentEnquiryReply>> getStudentEnquiryReplies({
    required String studentEnquiryUlid,
  });
  Future<PRFStudentEnquiryReply> createStudentEnquiryReply({
    required PRFStudentEnquiryReplyDTO studentEnquiryReplyDTO,
  });
}

class StudentServiceImpl implements StudentService {
  final _networkUtil = NetworkUtil();
  @override
  Future<List<PRFFaq>> getFaqs({
    String? include,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-faqs',
        queryParameters: {
          if (include != null) 'include': include,
          'limit': 500,
        },
      );

      return PRFFaqResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFFaqCategory>> getFaqCategories() async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-faq-categories',
      );

      return PRFFaqCategoryResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFStudentEnquiry>> getStudentEnquiries({
    String? studentUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/student-enquiries',
        queryParameters: {
          if (studentUlid != null) 'filter[student_ulid]': studentUlid,
        },
      );

      return PRFStudentEnquiryResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFStudentEnquiryReply>> getStudentEnquiryReplies({
    required String studentEnquiryUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/student-enquiry-replies',
        queryParameters: {
          'filter[student_enquiry_ulid]': studentEnquiryUlid,
        },
      );

      return PRFStudentEnquiryReplyResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFStudentEnquiry> createStudentEnquiry({
    required PRFStudentEnquiryDTO studentEnquiryDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/student-enquiries',
        body: json.encode(studentEnquiryDTO.toJson()),
      );

      return PRFStudentEnquiry.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFStudentEnquiryReply> createStudentEnquiryReply({
    required PRFStudentEnquiryReplyDTO studentEnquiryReplyDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/student-enquiry-replies',
        body: json.encode(studentEnquiryReplyDTO.toJson()),
      );

      return PRFStudentEnquiryReply.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
