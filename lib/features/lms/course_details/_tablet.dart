import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/course_details/_shared.dart';
import 'package:app/features/lms/course_details/cubit/course_details_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/widgets/course_details_action_card.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class CourseDetailsPageTablet extends StatefulWidget {
  const CourseDetailsPageTablet({required this.courseUlid, super.key});
  final String courseUlid;

  @override
  State<CourseDetailsPageTablet> createState() =>
      _CourseDetailsPageTabletState();
}

class _CourseDetailsPageTabletState extends State<CourseDetailsPageTablet> {
  late final _form = CourseDetailsFormState(courseUlid: widget.courseUlid);

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
            final modules =
                context.read<ModuleResourceCubit>().currentItems;
            final completedCount = modules
                .where(
                  (module) =>
                      (module.memberModule?.percentComplete ?? 0) >= 100,
                )
                .length;
            final isLoadingModules = moduleState.maybeWhen(
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
                    title: l10n.courseDetails,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.lmsRoute,
                    ),
                    isLoading: isLoadingModules && modules.isEmpty,
                    trailing: [
                      if (course != null)
                        CourseProgressBadge(
                          value: l10n.percentage(
                            course.courseMember?.percentComplete.toInt() ?? 0,
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<CourseDetailsResourceCubit>()
                            .loadCourse(
                              courseUlid: widget.courseUlid,
                              refresh: true,
                            );
                        await _form.load(context);
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(
                              PRFSpacingTokens.lg,
                            ),
                            sliver: moduleState.maybeWhen(
                              orElse: () => const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                              ),
                              listLoading: (_) =>
                                  modules.isEmpty
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
                                        description: l10n.noModulesDesc,
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
                                        child: CourseDetailsActionCard(
                                          courseModule: values[index],
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
                  PRFPanelSectionLabel(course?.name ?? l10n.courseDetails),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  Wrap(
                    spacing: PRFSpacingTokens.sm,
                    runSpacing: PRFSpacingTokens.sm,
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
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  Center(
                    child: Icon(
                      Icons.auto_stories_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.completeAllModules,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  Text(
                    l10n.modulesPanelBody,
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
