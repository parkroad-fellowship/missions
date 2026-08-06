import 'package:app/features/lms/_shared.dart';
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

class CourseDetailsPageTablet extends StatefulWidget {
  const CourseDetailsPageTablet({required this.courseUlid, super.key});
  final String courseUlid;

  @override
  State<CourseDetailsPageTablet> createState() =>
      _CourseDetailsPageTabletState();
}

class _CourseDetailsPageTabletState extends State<CourseDetailsPageTablet> {
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
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

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
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Column - Modules list (flex: 3)
                        Expanded(
                          flex: 3,
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
                                        const SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Center(
                                            child:
                                                PRFCircularProgressIndicator(),
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

                                      return SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: columns,
                                              crossAxisSpacing:
                                                  PRFSpacingTokens.lg,
                                              mainAxisSpacing:
                                                  PRFSpacingTokens.lg,
                                              childAspectRatio: 1.4,
                                            ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            return CourseDetailsActionCard(
                                                  courseModule: values[index],
                                                )
                                                .animate(
                                                  delay: Duration(
                                                    milliseconds: 70 * index,
                                                  ),
                                                )
                                                .fadeIn(
                                                  duration: PRFMotionTokens
                                                      .enterShort,
                                                )
                                                .slideY(
                                                  begin: 0.22,
                                                  end: 0,
                                                  duration: PRFMotionTokens
                                                      .enterMedium,
                                                  curve: Curves.easeOutCubic,
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

                        // Vertical Divider
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.12,
                          ),
                        ),

                        // Right Column - Course Details Card (flex: 2)
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.lg,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () =>
                                          context.router.popUntilRouteWithPath(
                                            PRFSuperAppRouter.lmsRoute,
                                          ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.courseDetails,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    if (course != null)
                                      CourseProgressBadge(
                                        value: l10n.percentage(
                                          course.courseMember?.percentComplete
                                                  .toInt() ??
                                              0,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: PRFSpacingTokens.xl),

                                // Course Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.xl,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.md,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course?.name ?? l10n.courseDetails,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: PRFSpacingTokens.xl,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LmsStatPill(
                                              label: l10n.total,
                                              value: modules.length,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: PRFSpacingTokens.sm,
                                          ),
                                          Expanded(
                                            child: LmsStatPill(
                                              label: l10n.completed,
                                              value: completedCount,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Additional visual help
                                Center(
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    size: 64,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Text(
                                  'Complete all Modules',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: PRFSpacingTokens.sm),
                                Text(
                                  'Each module has specific learning content and lessons. View and study module actions on the left panel.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
