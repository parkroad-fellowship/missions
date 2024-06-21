import 'package:app/features/home/lms/lesson_details/_handset.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class LessonDetailsPage extends StatelessWidget {
  const LessonDetailsPage({
    required this.lesson,
    super.key,
  });

  final PRFLocalLesson lesson;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => LessonDetailsHandset(lesson: lesson),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => LessonDetailsHandset(lesson: lesson),
      ),
    );
  }
}
