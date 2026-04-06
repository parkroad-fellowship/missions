import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/widgets/course_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class LMSPageHandset extends StatefulWidget {
  const LMSPageHandset({super.key});

  @override
  State<LMSPageHandset> createState() => _LMSPageHandsetState();
}

class _LMSPageHandsetState extends State<LMSPageHandset> {
  @override
  void initState() {
    context.read<CourseResourceCubit>().loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

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
                    PRFBrandedNavBar(title: l10n.learn),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.xs,
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.lg,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
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
                              l10n.learnSomething,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Wrap(
                              spacing: PRFSpacingTokens.xs,
                              runSpacing: PRFSpacingTokens.xs,
                              children: [
                                _LmsStatPill(
                                  label: l10n.total,
                                  value: courses.length,
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
                  onRefresh: () =>
                      context.read<CourseResourceCubit>().loadAll(),
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
                                            l10n.recentCourses,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.78),
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

                                final courseIndex = index - 1;
                                return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: courseIndex == values.length - 1
                                            ? 0
                                            : PRFSpacingTokens.lg,
                                      ),
                                      child: CourseActionCard(
                                        course: values[courseIndex],
                                      ),
                                    )
                                    .animate(
                                      delay: Duration(
                                        milliseconds: 70 * courseIndex,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideY(
                                      begin: 0.22,
                                      end: 0,
                                      duration: PRFMotionTokens.enterMedium,
                                      curve: Curves.easeOutCubic,
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
