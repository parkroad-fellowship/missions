import 'package:app/features/missions/cubit/school_details_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SchoolMissionsFormState {
  SchoolMissionsFormState({required this.schoolUlid});

  final String schoolUlid;

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context, {bool refresh = false}) {
    context.read<SchoolDetailsResourceCubit>().loadSchool(
      schoolUlid: schoolUlid,
      refresh: refresh,
    );
  }

  void dispose() {}
}

Widget buildSchoolInfoChip(
  ThemeData theme, {
  required IconData icon,
  required String label,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: PRFSpacingTokens.sm,
      vertical: PRFSpacingTokens.xs,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: PRFSpacingTokens.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

Widget buildSchoolHeader(BuildContext context, PRFSchool school) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: PRFOpacities.subtle,
              ),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
            ),
            child: Icon(
              Icons.school_rounded,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.xs),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: PRFSpacingTokens.xs),
                    Expanded(
                      child: Text(
                        school.address,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: PRFSpacingTokens.sm),
      Row(
        children: [
          buildSchoolInfoChip(
            theme,
            icon: Icons.people_rounded,
            label: context.l10n.students(school.totalStudents),
          ),
          const SizedBox(width: PRFSpacingTokens.sm),
          buildSchoolInfoChip(
            theme,
            icon: Icons.flag_rounded,
            label: context.l10n.missions_2(school.missions.length),
          ),
        ],
      ),
    ],
  );
}
