import 'package:app/features/lms/lesson_details/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
    return LessonDetailsHandset(
      lessonModuleUlid: lessonModuleUlid,
      courseModuleUlid: courseModuleUlid,
    );
  }
}
