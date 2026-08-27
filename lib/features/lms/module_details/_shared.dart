import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/models/remote/course/prf_module.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

class ModuleDetailsFormState {
  ModuleDetailsFormState({required this.courseModuleUlid});

  final String courseModuleUlid;
  late PRFCourseModule? courseModule;

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    Logger().f('ABCD: ModuleDetailsFormState.load() called for courseModuleUlid: $courseModuleUlid');
    final moduleCubit = context.read<ModuleResourceCubit>();
    final existingModule = moduleCubit.currentItems.firstWhereOrNull(
      (m) => m.ulid == courseModuleUlid,
    );
    Logger().f('ABCD: Existing module found: ${existingModule?.module?.name ?? 'None'}');

    if (existingModule != null) {
      courseModule = existingModule;
      context.read<LessonResourceCubit>().loadAll(
        filters: {'module_ulid': existingModule.module?.ulid},
      );
    } else {
      moduleCubit.loadAll().then((_) {
        final module = moduleCubit.currentItems.firstWhereOrNull(
          (m) => m.ulid == courseModuleUlid,
        );
        if (module != null) {
          // ignore: use_build_context_synchronously
          context.read<LessonResourceCubit>().loadAll(
            filters: {'module_ulid': module.module?.ulid},
          );
        }
      });
    }
  }

  void dispose() {}
}

class ModuleProgressBadge extends StatelessWidget {
  const ModuleProgressBadge({required this.value, super.key});

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

Widget buildModuleDetailsHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFCourseModule? courseModule,
  List<PRFLessonModule> lessonModules,
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
          title: l10n.moduleDetails,
          actions: [
            if (courseModule != null)
              ModuleProgressBadge(
                value: l10n.percentage(
                  courseModule.memberModule?.percentComplete.toInt() ?? 0,
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
                  courseModule?.module?.name ?? l10n.moduleDetails,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: PRFOpacities.nearOpaque,
                    ),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Wrap(
                  spacing: PRFSpacingTokens.xs,
                  runSpacing: PRFSpacingTokens.xs,
                  children: [
                    LmsStatPill(
                      label: l10n.total,
                      value: lessonModules.length,
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
