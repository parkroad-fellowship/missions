import 'package:app/features/student_home/enquiries/_handset.dart';
import 'package:app/features/student_home/enquiries/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class LearnerEnquiriesPage extends StatelessWidget {
  const LearnerEnquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const LearnerEnquiriesPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const LearnerEnquiriesPageHandset(),
      ),
    );
  }
}
