import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/lms/widgets/course_action_card.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class LMSPageTablet extends StatefulWidget {
  const LMSPageTablet({super.key});

  @override
  State<LMSPageTablet> createState() => _LMSPageTabletState();
}

class _LMSPageTabletState extends State<LMSPageTablet> {
  final _form = LMSFormState();

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

    return BlocBuilder<CourseResourceCubit, ResourceState<PRFCourse>>(
      builder: (context, state) {
        final courses = context.read<CourseResourceCubit>().currentItems;
        final completedCount = courses
            .where(
              (course) => (course.courseMember?.percentComplete ?? 0) >= 100,
            )
            .length;

        // The entrance cascade plays exactly once per screen instance;
        // later rebuilds (refresh setState) and scrolled-in cards skip it.
        final animateEntrance = !_entrancePlayed;
        _entrancePlayed = true;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.learn,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _form.load(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) => courses.isEmpty
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
                                label: l10n.noCourses,
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
                                    label: l10n.noCourses,
                                    description: l10n.noCoursesDesc,
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
                                    child: CourseActionCard(
                                      course: values[index],
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
              PRFPanelSectionLabel(l10n.learn),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.learnSomething,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Wrap(
                spacing: PRFSpacingTokens.sm,
                runSpacing: PRFSpacingTokens.sm,
                children: [
                  LmsStatPill(
                    label: l10n.total,
                    value: courses.length,
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
                  Icons.school_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.growInKnowledge,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.lmsPanelBody,
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
  }
}
