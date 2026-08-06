import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class CourseDetailsFormState {
  CourseDetailsFormState({required this.courseUlid});

  final String courseUlid;

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    context.read<ModuleResourceCubit>().loadAll(
      filters: {'course_ulid': courseUlid},
    );
  }

  void dispose() {}
}

class CourseProgressBadge extends StatelessWidget {
  const CourseProgressBadge({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      ),
      child: Text(
        value,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Widget buildCourseDetailsHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFCourse? course,
  List<PRFCourseModule> modules,
  int completedCount,
  VoidCallback onBack,
) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.88),
        ],
      ),
    ),
    child: Column(
      children: [
        PRFBrandedNavBar(
          onBack: onBack,
          title: l10n.courseDetails,
          actions: [
            if (course != null)
              CourseProgressBadge(
                value: l10n.percentage(
                  course.courseMember?.percentComplete.toInt() ?? 0,
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.xs,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.lg,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              PRFSpacingTokens.md,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(
                PRFRadiusTokens.lg,
              ),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withValues(
                  alpha: 0.15,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course?.name ?? l10n.courseDetails,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Wrap(
                  spacing: PRFSpacingTokens.xs,
                  runSpacing: PRFSpacingTokens.xs,
                  children: [
                    LmsStatPill(
                      label: l10n.total,
                      value: modules.length,
                    ),
                    LmsStatPill(
                      label: l10n.completed,
                      value: completedCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
