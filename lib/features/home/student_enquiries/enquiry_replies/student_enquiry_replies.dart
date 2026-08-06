import 'package:app/features/home/student_enquiries/enquiry_replies/_handset.dart';
import 'package:app/features/home/student_enquiries/enquiry_replies/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class StudentEnquiryRepliesPage extends StatelessWidget {
  const StudentEnquiryRepliesPage({required this.enquiryUlid, super.key});

  final String enquiryUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) =>
          StudentEnquiryRepliesPageHandset(enquiryUlid: enquiryUlid),
      handset: (context) =>
          StudentEnquiryRepliesPageHandset(enquiryUlid: enquiryUlid),
      tablet: (context) =>
          StudentEnquiryRepliesPageTablet(enquiryUlid: enquiryUlid),
    );
  }
}
