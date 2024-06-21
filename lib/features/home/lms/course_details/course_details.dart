import 'package:app/features/home/lms/course_details/_handset.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({
    required this.course,
    super.key,
  });

  final PRFLocalCourse course;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => CourseDetailsPageHandset(course: course),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => CourseDetailsPageHandset(course: course),
      ),
    );
  }
}
