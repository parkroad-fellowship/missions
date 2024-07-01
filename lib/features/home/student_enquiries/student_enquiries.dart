import 'package:app/features/home/student_enquiries/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class StudentEnquiriesPage extends StatelessWidget {
  const StudentEnquiriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const StudentEnquiriesPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const StudentEnquiriesPageHandset(),
      ),
    );
  }
}
