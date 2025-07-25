import 'package:app/features/home/student_enquiries/enquiry_replies/_handset.dart';
import 'package:app/features/home/student_enquiries/enquiry_replies/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class StudentEnquiryRepliesPage extends StatelessWidget {
  const StudentEnquiryRepliesPage({required this.enquiryUlid, super.key});

  final String enquiryUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) =>
          StudentEnquiryRepliesPageTablet(enquiryUlid: enquiryUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) =>
            StudentEnquiryRepliesPageHandset(enquiryUlid: enquiryUlid),
      ),
    );
  }
}
