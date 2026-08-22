import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/_shared.dart';
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

class ModuleDetailsPageTablet extends StatefulWidget {
  const ModuleDetailsPageTablet({required this.courseModuleUlid, super.key});
  final String courseModuleUlid;

  @override
  State<ModuleDetailsPageTablet> createState() =>
      _ModuleDetailsPageTabletState();
}

class _ModuleDetailsPageTabletState extends State<ModuleDetailsPageTablet> {
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

    return BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
      builder: (context, moduleState) {
        return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
          builder: (context, lessonState) {
            final courseModule = moduleState.maybeWhen(
              listLoaded: (items, _, _) =>
                  items.isNotEmpty ? items.first : null,
              orElse: () => null,
            );
            final lessonModules =
                context.read<LessonResourceCubit>().currentItems;
            final completedCount = lessonModules
                .where(
                  (lessonModule) =>
                      lessonModule.lessonMember?.completionStatus ==
                      PRFCompletionStatus.complete,
                )
                .length;
            final isLoadingLessons = lessonState.maybeWhen(
              listLoading: (_) => true,
              orElse: () => false,
            );

            // The entrance cascade plays exactly once per screen instance;
            // later rebuilds (refresh setState) and scrolled-in cards skip it.
            final animateEntrance = !_entrancePlayed;
            _entrancePlayed = true;

            return PRFTabletSplitScaffold(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PRFTabletHeaderRow(
                    title: l10n.moduleDetails,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.courseDetailsRoute,
                    ),
                    isLoading: isLoadingLessons && lessonModules.isEmpty,
                    trailing: [
                      if (courseModule != null)
                        ModuleProgressBadge(
                          value: l10n.percentage(
                            courseModule.memberModule?.percentComplete
                                    .toInt() ??
                                0,
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<ModuleResourceCubit>()
                            .loadAll(
                              filters: {'ulid': widget.courseModuleUlid},
                            );
                        final module = context
                            .read<ModuleResourceCubit>()
                            .currentItems
                            .firstWhereOrNull(
                              (module) =>
                                  module.ulid == widget.courseModuleUlid,
                            );
                        if (module != null) {
                          await context
                              .read<LessonResourceCubit>()
                              .loadAll(
                                filters: {
                                  'module_ulid': module.module?.ulid,
                                },
                              );
                        }
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
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.lg,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.md,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.md,
                                    ),
                                    border: Border.all(
                                      color: theme.colorScheme.outline
                                          .withValues(alpha: 0.12),
                                    ),
                                  ),
                                  child: Text(
                                    courseModule!.module!.description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            sliver: lessonState.maybeWhen(
                              orElse: () => const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                              ),
                              listLoading: (_) =>
                                  lessonModules.isEmpty
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
                                        description: l10n.noLessonsDesc,
                                      ),
                                    ),
                                  );
                                }

                                return SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 340,
                                    crossAxisSpacing: PRFSpacingTokens.lg,
                                    mainAxisSpacing: PRFSpacingTokens.lg,
                                    childAspectRatio: 1.4,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return buildAnimatedTimelineEntry(
                                        context: context,
                                        index: index,
                                        animate: animateEntrance,
                                        child: ModuleDetailsActionCard(
                                          lessonModule: values[index],
                                          courseModuleUlid:
                                              widget.courseModuleUlid,
                                        ),
                                      );
                                    },
                                    childCount: values.length,
                                  ),
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
              sidePanel: PRFBrandPanel(
                children: [
                  PRFPanelSectionLabel(
                    courseModule?.module?.name ?? l10n.moduleDetails,
                  ),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  Wrap(
                    spacing: PRFSpacingTokens.sm,
                    runSpacing: PRFSpacingTokens.sm,
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
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  Center(
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.studyYourLessons,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  Text(
                    l10n.lessonsPanelBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: PRFColors.navy100,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
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
