import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ModuleDetailsActionCard extends StatelessWidget {
  const ModuleDetailsActionCard({
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.router.push(
        LessonDetailsRoute(
          lessonModule: lessonModule,
          courseUlid: courseUlid,
          moduleUlid: moduleUlid,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
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
                    lessonModule.lesson.name!.toUpperCase(),
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Icon(
                    lessonModule.lessonMember?.completionStatus?.icon ??
                        Icons.watch_later_outlined,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              lessonModule.lesson.description ?? '',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
