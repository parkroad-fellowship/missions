import 'package:app/features/home/lms/course_details/_handset.dart';
import 'package:app/features/home/lms/course_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({required this.courseUlid, super.key});

  final String courseUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => CourseDetailsPageTablet(courseUlid: courseUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => CourseDetailsPageHandset(courseUlid: courseUlid),
      ),
    );
  }
}
