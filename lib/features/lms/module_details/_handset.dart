import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/module_details/_shared.dart';
import 'package:app/features/lms/widgets/module_details_action_card.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  late final _form = ModuleDetailsFormState(
    courseModuleUlid: widget.courseModuleUlid,
  );

  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

    return BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
      builder: (context, moduleState) {
        return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
          builder: (context, lessonState) {
            final courseModule = moduleState.maybeWhen(
              listLoaded: (items, _, _) =>
                  items.isNotEmpty ? items.first : null,
              orElse: () => null,
            );
            // Same source as the list: pull-to-refresh keeps cards visible
            // instead of flashing a full-screen spinner.
            final lessonModules = context
                .read<LessonResourceCubit>()
                .currentItems;
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
                  buildModuleDetailsHeader(
                    context,
                    theme,
                    l10n,
                    courseModule,
                    lessonModules,
                    completedCount,
                    () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.courseDetailsRoute,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<ModuleResourceCubit>()
                            .loadAll(
                              filters: {'ulid': widget.courseModuleUlid},
                            )
                            .then((_) {
                              final module = context
                                  .read<ModuleResourceCubit>()
                                  .currentItems
                                  .firstWhereOrNull(
                                    (module) =>
                                        module.ulid == widget.courseModuleUlid,
                                  );
                              if (module != null) {
                                context.read<LessonResourceCubit>().loadAll(
                                  filters: {
                                    'module_ulid': module.module?.ulid,
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
                              listLoading: (_) => lessonModules.isEmpty
                                  ? const SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Center(
                                        child: PRFCircularProgressIndicator(),
                                      ),
                                    )
                                  : const SliverToBoxAdapter(
                                      child: SizedBox.shrink(),
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
                                        description: l10n.noModulesDesc,
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
                                    return buildAnimatedTimelineEntry(
                                      context: context,
                                      index: lessonIndex,
                                      animate: animateEntrance,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              lessonIndex == values.length - 1
                                              ? 0
                                              : PRFSpacingTokens.lg,
                                        ),
                                        child: ModuleDetailsActionCard(
                                          lessonModule: values[lessonIndex],
                                          courseModuleUlid:
                                              widget.courseModuleUlid,
                                        ),
                                      ),
                                    );
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
