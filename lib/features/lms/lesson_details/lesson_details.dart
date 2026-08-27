import 'package:app/features/lms/lesson_details/_handset.dart';
import 'package:app/features/lms/lesson_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class LessonDetailsPage extends StatelessWidget {
  const LessonDetailsPage({
    required this.lessonModuleUlid,
    required this.courseModuleUlid,
    super.key,
  });

  final String lessonModuleUlid;
  final String courseModuleUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => LessonDetailsTablet(
        lessonModuleUlid: lessonModuleUlid,
        courseModuleUlid: courseModuleUlid,
      ),
      handset: (context) => LessonDetailsHandset(
        lessonModuleUlid: lessonModuleUlid,
        courseModuleUlid: courseModuleUlid,
      ),
      tablet: (context) => LessonDetailsTablet(
        lessonModuleUlid: lessonModuleUlid,
        courseModuleUlid: courseModuleUlid,
      ),
    );
  }
}
