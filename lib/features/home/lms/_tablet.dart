import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/features/home/lms/widgets/course_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/navbar/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LMSPageTablet extends StatefulWidget {
  const LMSPageTablet({super.key});

  @override
  State<LMSPageTablet> createState() => _LMSPageTabletState();
}

class _LMSPageTabletState extends State<LMSPageTablet> {
  @override
  void initState() {
    context.read<GetCoursesCubit>().getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              PRFNavBar(
                title: l10n.learn,
                backgroundColor: theme.colorScheme.surface,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<GetCoursesCubit, GetCoursesState>(
                  builder: (context, state) => state.maybeWhen(
                    loading: () => const PRFLinearProgressIndicator(),
                    orElse: SizedBox.shrink,
                  ),
                ),
              ),
              StreamBuilder(
                stream: getIt<LocalDBService>().getCourses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: PRFCircularProgressIndicator()),
                    );
                  }

                  final courses = snapshot.data;

                  if (courses != null && courses.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: RefreshIndicator(
                        onRefresh: () =>
                            context.read<GetCoursesCubit>().getCourses(),
                        child: PRFEmptyView(
                          label: l10n.noCourses,
                          description: l10n.pleaseWait,
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: courses!.length,
                    itemBuilder: (context, index) =>
                        CourseActionCard(course: courses[index]),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
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
