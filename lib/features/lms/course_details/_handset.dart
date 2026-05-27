import 'package:app/features/lms/course_details/cubit/course_details_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/widgets/course_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class CourseDetailsPageHandset extends StatefulWidget {
  const CourseDetailsPageHandset({required this.courseUlid, super.key});
  final String courseUlid;

  @override
  State<CourseDetailsPageHandset> createState() =>
      _CourseDetailsPageHandsetState();
}

class _CourseDetailsPageHandsetState extends State<CourseDetailsPageHandset> {
  String get courseUlid => widget.courseUlid;

  @override
  void initState() {
    context.read<ModuleResourceCubit>().loadAll(
      filters: {'course_ulid': courseUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<CourseDetailsResourceCubit, ResourceState<PRFCourse>>(
      builder: (context, courseState) {
        return BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
          builder: (context, moduleState) {
            final course = courseState.maybeWhen(
              itemLoaded: (item, _) => item,
              itemLoading: (_, item) => item,
              itemError: (_, _, item) => item,
              orElse: () => null,
            );
            final modules = moduleState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFCourseModule>.empty,
            );
            final completedCount = modules
                .where(
                  (module) =>
                      (module.memberModule?.percentComplete ?? 0) >= 100,
                )
                .length;

            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: Column(
                children: [
                  Container(
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
                          onBack: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.lmsRoute,
                          ),
                          title: l10n.courseDetails,
                          actions: [
                            if (course != null)
                              _CourseProgressBadge(
                                value: l10n.percentage(
                                  course.courseMember?.percentComplete
                                          .toInt() ??
                                      0,
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
                                    color: theme.colorScheme.onPrimary
                                        .withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Wrap(
                                  spacing: PRFSpacingTokens.xs,
                                  runSpacing: PRFSpacingTokens.xs,
                                  children: [
                                    _LmsStatPill(
                                      label: l10n.total,
                                      value: modules.length,
                                    ),
                                    _LmsStatPill(
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
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<CourseDetailsResourceCubit>()
                            .loadCourse(
                              courseUlid: courseUlid,
                              refresh: true,
                            );
                        await context.read<ModuleResourceCubit>().loadAll(
                          filters: {'course_ulid': courseUlid},
                        );
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              PRFSpacingTokens.lg,
                              PRFSpacingTokens.lg,
                              PRFSpacingTokens.lg,
                              PRFSpacingTokens.xl,
                            ),
                            sliver: moduleState.maybeWhen(
                              orElse: () => const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                              ),
                              listLoading: (_) => const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                              ),
                              error: (message, _) => SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.noModules,
                                    description: message,
                                  ),
                                ),
                              ),
                              listLoaded: (values, _, _) {
                                if (values.isEmpty) {
                                  return SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: PRFEmptyView(
                                        label: l10n.noModules,
                                        description: l10n.pleaseWait,
                                      ),
                                    ),
                                  );
                                }

                                return SliverList.builder(
                                  itemCount: values.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: PRFSpacingTokens.md,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                l10n.recentModules,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.78,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              '${values.length}',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    final moduleIndex = index - 1;
                                    return Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                moduleIndex == values.length - 1
                                                ? 0
                                                : PRFSpacingTokens.lg,
                                          ),
                                          child: CourseDetailsActionCard(
                                            courseModule: values[moduleIndex],
                                          ),
                                        )
                                        .animate(
                                          delay: Duration(
                                            milliseconds: 70 * moduleIndex,
                                          ),
                                        )
                                        .fadeIn(
                                          duration: PRFMotionTokens.enterShort,
                                        )
                                        .slideY(begin: 0.22, end: 0);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LmsStatPill extends StatelessWidget {
  const _LmsStatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseProgressBadge extends StatelessWidget {
  const _CourseProgressBadge({required this.value});

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
