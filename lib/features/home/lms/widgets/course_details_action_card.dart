import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/course/prf_course_module.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class CourseDetailsActionCard extends StatelessWidget {
  const CourseDetailsActionCard({required this.courseModule, super.key});

  final PRFLocalCourseModule courseModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.router.push(
        ModuleDetailsRoute(courseModuleUlid: courseModule.ulid),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl, vertical: PRFSpacingTokens.xxl),
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
                    courseModule.module.name!,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                    vertical: PRFSpacingTokens.xs,
                  ),
                  child: Text(
                    l10n.percentage(
                      courseModule.memberModule?.percentComplete?.toInt() ?? 0,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Text(
              courseModule.module.description!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
