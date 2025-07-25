import 'package:app/features/home/lms/lesson_details/_handset.dart';
import 'package:app/features/home/lms/lesson_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

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
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => LessonDetailsTablet(
        lessonModuleUlid: lessonModuleUlid,
        courseModuleUlid: courseModuleUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => LessonDetailsHandset(
          lessonModuleUlid: lessonModuleUlid,
          courseModuleUlid: courseModuleUlid,
        ),
      ),
    );
  }
}
