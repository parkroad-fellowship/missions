import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class CourseDetailsActionCard extends StatelessWidget {
  const CourseDetailsActionCard({required this.courseModule, super.key});

  final PRFCourseModule courseModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return PRFDetailActionCard(
      title: courseModule.module?.name ?? '',
      subtitle: courseModule.module?.description ?? '',
      onTap: () => context.router.push(
        ModuleDetailsRoute(courseModuleUlid: courseModule.ulid),
      ),
      trailing: Container(
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
            courseModule.memberModule?.percentComplete.toInt() ?? 0,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
