import 'package:app/enums/payment/prf_completion_status.dart';
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

    final isCompleted =
        lessonModule.lessonMember?.completionStatus ==
        PRFCompletionStatus.complete;
    final statusLabel =
        lessonModule.lessonMember?.completionStatus.name.toUpperCase() ??
        PRFCompletionStatus.incomplete.name.toUpperCase();

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
            LessonDetailsRoute(
              lessonModuleUlid: lessonModule.ulid,
              courseModuleUlid: courseModuleUlid,
            ),
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
                        Icons.menu_book_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.md),
                    Expanded(
                      child: Text(
                        (lessonModule.lesson?.name ?? '').toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PRFStatusBadge(
                      label: statusLabel,
                      color: isCompleted
                          ? context.statusColors.completed.main
                          : context.statusColors.pending.main,
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
                  lessonModule.lesson?.description ?? '',
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
