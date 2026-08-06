import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/lms/widgets/course_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class LMSPageTablet extends StatefulWidget {
  const LMSPageTablet({super.key});

  @override
  State<LMSPageTablet> createState() => _LMSPageTabletState();
}

class _LMSPageTabletState extends State<LMSPageTablet> {
  final _form = LMSFormState();

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

    return BlocBuilder<CourseResourceCubit, ResourceState<PRFCourse>>(
      builder: (context, state) {
        final courses = state.maybeWhen(
          listLoaded: (values, _, _) => values,
          orElse: List<PRFCourse>.empty,
        );
        final completedCount = courses
            .where(
              (course) => (course.courseMember?.percentComplete ?? 0) >= 100,
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
                    // Left Column - Courses list/grid (flex: 3)
                    Expanded(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: () async => _form.load(context),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.lg,
                              ),
                              sliver: state.maybeWhen(
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
                                          description: l10n.pleaseWait,
                                        ),
                                      ),
                                    );
                                  }
                                  return SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: columns,
                                          crossAxisSpacing: PRFSpacingTokens.lg,
                                          mainAxisSpacing: PRFSpacingTokens.lg,
                                          childAspectRatio: 1.4,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return CourseActionCard(
                                              course: values[index],
                                            )
                                            .animate(
                                              delay: Duration(
                                                milliseconds: 70 * index,
                                              ),
                                            )
                                            .fadeIn(
                                              duration:
                                                  PRFMotionTokens.enterShort,
                                            )
                                            .slideY(
                                              begin: 0.22,
                                              end: 0,
                                              duration:
                                                  PRFMotionTokens.enterMedium,
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
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - LMS Statistics & Brand Panel (flex: 2)
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
                            Text(
                              l10n.learn,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Learning Stat Panel
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.learnSomething,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LmsStatPill(
                                          label: l10n.total,
                                          value: courses.length,
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

                            // Helpful guidance card
                            Center(
                              child: Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Grow in Knowledge',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Acquire wisdom and understanding through structured learning courses. Take courses, complete modules, and learn at your own pace.',
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
  }
}
