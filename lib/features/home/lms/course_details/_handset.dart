import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/home/lms/widgets/course_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    context.read<CourseResourceCubit>().loadAll(
      filters: {'course_ulid': courseUlid},
    );
    context.read<ModuleResourceCubit>().loadAll(
      filters: {'course_ulid': courseUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.lmsRoute,
              ),
              title: l10n.courseDetails,
              backgroundColor: theme.colorScheme.surface,
              actions: [
                BlocBuilder<CourseResourceCubit, ResourceState<PRFCourse>>(
                  builder: (context, state) {
                    final course = state.maybeWhen(
                      listLoaded: (items, _, _) =>
                          items.isNotEmpty ? items.first : null,
                      orElse: () => null,
                    );
                    if (course == null) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.md,
                        vertical: PRFSpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.13,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.percentage(
                          course.courseMember?.percentComplete.toInt() ?? 0,
                        ),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child:
                  BlocBuilder<
                    ModuleResourceCubit,
                    ResourceState<PRFCourseModule>
                  >(
                    builder: (context, state) => state.maybeWhen(
                      listLoading: () => const Padding(
                        padding: EdgeInsets.only(bottom: PRFSpacingTokens.lg),
                        child: PRFLinearProgressIndicator(),
                      ),
                      orElse: SizedBox.shrink,
                    ),
                  ),
            ),
            BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
              builder: (context, state) {
                return state.maybeWhen(
                  listLoaded: (courseModules, _, _) {
                    if (courseModules.isEmpty) {
                      return SliverToBoxAdapter(
                        child: PRFEmptyView(
                          label: l10n.noModules,
                          description: l10n.pleaseWait,
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: courseModules.length,
                      itemBuilder: (context, index) => CourseDetailsActionCard(
                        courseModule: courseModules[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: PRFSpacingTokens.lg),
                    );
                  },
                  error: (message, _) => SliverToBoxAdapter(
                    child: Center(child: Text(message)),
                  ),
                  orElse: () => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
