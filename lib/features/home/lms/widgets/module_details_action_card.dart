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

    return GestureDetector(
      onTap: () => context.router.push(
        LessonDetailsRoute(
          lessonModuleUlid: lessonModule.ulid,
          courseModuleUlid: courseModuleUlid,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.lg,
          vertical: PRFSpacingTokens.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.xl,
          vertical: PRFSpacingTokens.xxl,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (lessonModule.lesson?.name ?? '').toUpperCase(),
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Container(
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
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Text(
              lessonModule.lesson?.description ?? '',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
