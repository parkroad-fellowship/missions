import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    context.read<GetCourseModulesCubit>().getCourseModules(
      courseUlid: courseUlid,
    );
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
                                PRFSuperAppRouter.lmsRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      SingleStreamWrapper<PRFLocalCourse>(
                        stream: getIt<LocalDBService>().getCourse(
                          courseUlid: courseUlid,
                        ),
                        widget:
                            (context, course) => SizedBox(
                              child: Text(
                                course.name,
                                style: Theme.of(context).textTheme.displayLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                      ),

                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: SingleStreamWrapper<PRFLocalCourse>(
                          stream: getIt<LocalDBService>().getCourse(
                            courseUlid: courseUlid,
                          ),
                          widget:
                              (context, course) => Text(
                                l10n.percentage(
                                  course.courseMember?.percentComplete!
                                          .toInt() ??
                                      0,
                                ),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),

              SliverToBoxAdapter(
                child: SingleStreamWrapper<PRFLocalCourse>(
                  stream: getIt<LocalDBService>().getCourse(
                    courseUlid: courseUlid,
                  ),
                  widget:
                      (context, course) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          course.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    l10n.modules,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              SliverToBoxAdapter(
                child:
                    BlocBuilder<GetCourseModulesCubit, GetCourseModulesState>(
                      builder:
                          (context, state) => state.maybeWhen(
                            loading:
                                () => const Center(
                                  child: LinearProgressIndicator(),
                                ),
                            orElse: SizedBox.shrink,
                          ),
                    ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              StreamBuilder<List<PRFLocalCourseModule>>(
                stream: getIt<LocalDBService>().getCourseModules(
                  courseUlid: courseUlid,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final courseModules = snapshot.data;

                  if (courseModules != null && courseModules.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverList.separated(
                    itemCount: courseModules!.length,
                    itemBuilder:
                        (context, index) => CourseDetailsActionCard(
                          courseModule: courseModules[index],
                        ),
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

class CourseDetailsActionCard extends StatelessWidget {
  const CourseDetailsActionCard({required this.courseModule, super.key});

  final PRFLocalCourseModule courseModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap:
          () => context.router.push(
            ModuleDetailsRoute(courseModule: courseModule),
          ),
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 80.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 8,
                      child: Text(
                        courseModule.module.name!,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
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
                            courseModule.memberModule?.percentComplete
                                    ?.toInt() ??
                                0,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  courseModule.module.description!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
