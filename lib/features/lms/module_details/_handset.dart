import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/widgets/module_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class ModuleDetailsPageHandset extends StatefulWidget {
  const ModuleDetailsPageHandset({
    required this.courseModuleUlid,
    super.key,
  });

  final String courseModuleUlid;

  @override
  State<ModuleDetailsPageHandset> createState() =>
      _ModuleDetailsPageHandsetState();
}

class _ModuleDetailsPageHandsetState extends State<ModuleDetailsPageHandset> {
  String get courseModuleUlid => widget.courseModuleUlid;

  @override
  void initState() {
    final moduleCubit = context.read<ModuleResourceCubit>();
    final existingModule = moduleCubit.currentItems.firstWhereOrNull(
      (m) => m.ulid == courseModuleUlid,
    );

    if (existingModule != null) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
      builder: (context, moduleState) {
        return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
          builder: (context, lessonState) {
            final courseModule = moduleState.maybeWhen(
              listLoaded: (items, _, _) =>
                  items.isNotEmpty ? items.first : null,
              orElse: () => null,
            );
            final lessonModules = lessonState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFLessonModule>.empty,
            );
            final completedCount = lessonModules
                .where(
                  (lessonModule) =>
                      lessonModule.lessonMember?.completionStatus ==
                      PRFCompletionStatus.complete,
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
                          title: l10n.moduleDetails,
                          onBack: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.courseDetailsRoute,
                          ),
                          actions: [
                            if (courseModule != null)
                              _ModuleProgressBadge(
                                value: l10n.percentage(
                                  courseModule.memberModule?.percentComplete
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
                                  courseModule?.module?.name ??
                                      l10n.moduleDetails,
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
                                      value: lessonModules.length,
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
                            .read<ModuleResourceCubit>()
                            .loadAll(
                              filters: {'ulid': courseModuleUlid},
                            )
                            .then((_) {
                              final module = context
                                  .read<ModuleResourceCubit>()
                                  .currentItems
                                  .firstWhereOrNull(
                                    (module) => module.ulid == courseModuleUlid,
                                  );
                              if (module != null) {
                                context.read<LessonResourceCubit>().loadAll(
                                  filters: {
                                    'module_ulid': module.module?.ulid,
                                    // 'course_ulid': module.course?.ulid,
                                  },
                                );
                              }
                            });
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          if ((courseModule?.module?.description ?? '')
                              .trim()
                              .isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                PRFSpacingTokens.lg,
                                PRFSpacingTokens.lg,
                                PRFSpacingTokens.lg,
                                PRFSpacingTokens.md,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: Text(
                                  courseModule!.module!.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              PRFSpacingTokens.lg,
                              PRFSpacingTokens.md,
                              PRFSpacingTokens.lg,
                              PRFSpacingTokens.xl,
                            ),
                            sliver: lessonState.maybeWhen(
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
                                    label: l10n.noLessons,
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
                                        label: l10n.noLessons,
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
                                                l10n.recentLessons,
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

                                    final lessonIndex = index - 1;
                                    return Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                lessonIndex == values.length - 1
                                                ? 0
                                                : PRFSpacingTokens.lg,
                                          ),
                                          child: ModuleDetailsActionCard(
                                            lessonModule: values[lessonIndex],
                                            courseModuleUlid: courseModuleUlid,
                                          ),
                                        )
                                        .animate(
                                          delay: Duration(
                                            milliseconds: 70 * lessonIndex,
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

class _ModuleProgressBadge extends StatelessWidget {
  const _ModuleProgressBadge({required this.value});

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
