import 'package:app/features/lms/course_details/_shared.dart';
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
  late final _form = CourseDetailsFormState(courseUlid: widget.courseUlid);

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
                  buildCourseDetailsHeader(
                    context,
                    theme,
                    l10n,
                    course,
                    modules,
                    completedCount,
                    () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.lmsRoute,
                    ),
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
                        _form.load(context);
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
