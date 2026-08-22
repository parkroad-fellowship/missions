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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: PRFShadowTokens.raised(theme.colorScheme.primary),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          onTap: () => context.router.push(
            ModuleDetailsRoute(courseModuleUlid: courseModule.ulid),
          ),
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                      ),
                      child: Icon(
                        Icons.view_module_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.md),
                    Expanded(
                      child: Text(
                        courseModule.module?.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PRFStatusBadge(
                      label: l10n.percentage(
                        courseModule.memberModule?.percentComplete.toInt() ?? 0,
                      ),
                      color: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.md,
                        vertical: PRFSpacingTokens.xs,
                      ),
                      boxShadow: const [],
                      textStyle: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Text(
                  courseModule.module?.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
