import 'package:app/features/home/student_enquiries/enquiry_replies/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class StudentEnquiryRepliesPage extends StatelessWidget {
  const StudentEnquiryRepliesPage({required this.enquiryUlid, super.key});

  final String enquiryUlid;

  @override
  Widget build(BuildContext context) {
    return StudentEnquiryRepliesPageHandset(enquiryUlid: enquiryUlid);
  }
}
