import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                           color: Theme.of(context).colorScheme.primary,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.landingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.learn,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Visibility(
                          child: Icon(Icons.abc, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetCoursesCubit, GetCoursesState>(
                  builder:
                      (context, state) => state.maybeWhen(
                        loading:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        orElse: SizedBox.shrink,
                      ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              StreamBuilder(
                stream: getIt<LocalDBService>().getCourses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final courses = snapshot.data;

                  if (courses != null && courses.isEmpty) {
                    return SliverFillRemaining(
                      child: RefreshIndicator(
                        onRefresh:
                            () => context.read<GetCoursesCubit>().getCourses(),
                        child: Column(
                          children: [
                            const Spacer(),
                            const Icon(Icons.directions_walk),
                            Center(
                              child: Text(
                                l10n.noCourses,
                                style: Theme.of(context).textTheme.headlineMedium!,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    l10n.pleaseWait,
                                    style: Theme.of(context).textTheme.displayLarge!
                                        ,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: courses!.length,
                    itemBuilder:
                        (context, index) =>
                            CourseActionCard(course: courses[index]),
                    separatorBuilder:
                        (context, index) => SizedBox(height: 16.h),
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

class CourseActionCard extends StatelessWidget {
  const CourseActionCard({required this.course, super.key});

  final PRFLocalCourse course;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [ScaleEffect()],
      child: GestureDetector(
        onTap:
            () => context.router.push(
              CourseDetailsRoute(courseUlid: course.ulid),
            ),
        child: Stack(
          children: [
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 80.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.secondary.withValues(alpha:.3),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          l10n.percentage(
                            course.courseMember?.percentComplete?.toInt() ?? 0,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
