import 'package:app/features/student_home/enquiries/enquiry_replies/_handset.dart';
import 'package:app/features/student_home/enquiries/enquiry_replies/_tablet.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class EnquiryRepliesPage extends StatelessWidget {
  const EnquiryRepliesPage({required this.enquiry, super.key});

  final PRFLocalStudentEnquiry enquiry;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => EnquiryRepliesPageTablet(enquiry: enquiry),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => EnquiryRepliesPageHandset(enquiry: enquiry),
      ),
    );
  }
}
