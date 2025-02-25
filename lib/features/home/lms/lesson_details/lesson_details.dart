import 'package:app/features/home/lms/lesson_details/_handset.dart';
import 'package:app/features/home/lms/lesson_details/_tablet.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class LessonDetailsPage extends StatelessWidget {
  const LessonDetailsPage({
    required this.lessonModule,
    required this.courseUlid,
    required this.moduleUlid,
    super.key,
  });

  final PRFLocalLessonModule lessonModule;
  final String courseUlid;
  final String moduleUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, __) => LessonDetailsTablet(
            lessonModule: lessonModule,
            courseUlid: courseUlid,
            moduleUlid: moduleUlid,
          ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset:
            (_, __) => LessonDetailsHandset(
              lessonModule: lessonModule,
              courseUlid: courseUlid,
              moduleUlid: moduleUlid,
            ),
      ),
    );
  }
}
