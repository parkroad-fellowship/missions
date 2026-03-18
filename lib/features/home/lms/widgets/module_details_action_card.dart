import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class ModuleDetailsActionCard extends StatelessWidget {
  const ModuleDetailsActionCard({
    required this.lessonModule,
    required this.courseModuleUlid,
    super.key,
  });

  final PRFLessonModule lessonModule;
  final String courseModuleUlid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PRFDetailActionCard(
      title: (lessonModule.lesson?.name ?? '').toUpperCase(),
      subtitle: lessonModule.lesson?.description ?? '',
      onTap: () => context.router.push(
        LessonDetailsRoute(
          lessonModuleUlid: lessonModule.ulid,
          courseModuleUlid: courseModuleUlid,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.sm,
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.sm,
          vertical: PRFSpacingTokens.xs,
        ),
        child: Icon(
          lessonModule.lessonMember?.completionStatus.icon ??
              Icons.watch_later_outlined,
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
      ),
    );
  }
}
