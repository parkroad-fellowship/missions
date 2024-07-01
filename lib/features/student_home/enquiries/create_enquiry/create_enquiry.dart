import 'package:app/features/student_home/enquiries/create_enquiry/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class CreateEnquiryPage extends StatelessWidget {
  const CreateEnquiryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const CreateEnquiryPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const CreateEnquiryPageHandset(),
      ),
    );
  }
}
