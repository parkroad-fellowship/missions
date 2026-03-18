import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class CourseActionCard extends StatelessWidget {
  const CourseActionCard({required this.course, super.key});

  final PRFCourse course;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return PRFDetailActionCard(
      title: course.name,
      subtitle: course.description,
      onTap: () => context.router.push(
        CourseDetailsRoute(courseUlid: course.ulid),
      ),
      backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.08),
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
            course.courseMember?.percentComplete.toInt() ?? 0,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
