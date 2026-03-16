import 'package:app/features/home/lms/cubit/get_course_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/features/home/lms/widgets/course_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/course/prf_course.dart';
import 'package:app/models/local/course/prf_course_module.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsPageTablet extends StatefulWidget {
  const CourseDetailsPageTablet({required this.courseUlid, super.key});

  final String courseUlid;

  @override
  State<CourseDetailsPageTablet> createState() =>
      _CourseDetailsPageTabletState();
}

class _CourseDetailsPageTabletState extends State<CourseDetailsPageTablet> {
  String get courseUlid => widget.courseUlid;

  @override
  void initState() {
    context.read<GetCourseCubit>().getCourse(
      courseUlid: courseUlid,
    );
    context.read<GetCourseModulesCubit>().getCourseModules(
      courseUlid: courseUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
          child: CustomScrollView(
            slivers: [
              PRFNavBar(
                title: l10n.courseDetails,
                backgroundColor: theme.colorScheme.surface,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.lmsRoute,
                ),
                actions: [
                  SingleStreamWrapper<PRFLocalCourse?>(
                    stream: getIt<IsarService>().courses.itemStream,
                    widget: (context, course) => Container(
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
                          course?.courseMember?.percentComplete?.toInt() ?? 0,
                        ),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child:
                    BlocBuilder<GetCourseModulesCubit, GetCourseModulesState>(
                      builder: (context, state) => state.maybeWhen(
                        loading: () => const Padding(
                          padding: EdgeInsets.only(bottom: PRFSpacingTokens.lg),

                          child: PRFLinearProgressIndicator(),
                        ),
                        orElse: SizedBox.shrink,
                      ),
                    ),
              ),
              StreamBuilder<List<PRFLocalCourseModule>>(
                stream: getIt<IsarService>().courseModules.parentStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: PRFCircularProgressIndicator()),
                    );
                  }

                  final courseModules = snapshot.data;

                  if (courseModules != null && courseModules.isEmpty) {
                    return SliverToBoxAdapter(
                      child: PRFEmptyView(
                        label: l10n.noModules,
                        description: l10n.pleaseWait,
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: courseModules!.length,
                    itemBuilder: (context, index) => CourseDetailsActionCard(
                      courseModule: courseModules[index],
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: PRFSpacingTokens.lg),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
