import 'package:app/features/home/student_enquiries/_handset.dart';
import 'package:app/features/home/student_enquiries/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class StudentEnquiriesPage extends StatelessWidget {
  const StudentEnquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const StudentEnquiriesPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const StudentEnquiriesPageHandset(),
      ),
    );
  }
}
