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
  const CourseDetailsPageHandset({
    required this.courseUlid,
    super.key,
  });

  final String courseUlid;

  @override
  State<CourseDetailsPageHandset> createState() =>
      _CourseDetailsPageHandsetState();
}

class _CourseDetailsPageHandsetState extends State<CourseDetailsPageHandset> {
  String get courseUlid => widget.courseUlid;

  @override
  void initState() {
    context
        .read<GetCourseModulesCubit>()
        .getCourseModules(courseUlid: courseUlid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Start Navigation Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: true,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.appTheme().kPrimaryColorV2,
                          width: 1.w,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: const EdgeInsets.only(left: 8),
                        onPressed: () => context.router.popUntilRouteWithPath(
                          PRFSuperAppRouter.landingRoute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StreamBuilder<PRFLocalCourse>(
                      stream: getIt<LocalDBService>()
                          .getCourse(courseUlid: courseUlid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(),
                          );
                        }
                        final course = snapshot.data;
                        return SizedBox(
                          width: 0.5.sw,
                          child: Text(
                            course!.name,
                            style: CustomTextTheme.customTextTheme()
                                .displayLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: StreamBuilder<PRFLocalCourse>(
                        stream: getIt<LocalDBService>()
                            .getCourse(courseUlid: courseUlid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final course = snapshot.data;
                          return Text(
                            l10n.percentage(
                              course!.courseMember?.percentComplete! ?? 0,
                            ),
                            style: CustomTextTheme.customTextTheme()
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // End Navigation Bar
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            SliverToBoxAdapter(
              child: StreamBuilder<PRFLocalCourse>(
                stream:
                    getIt<LocalDBService>().getCourse(courseUlid: courseUlid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final course = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      course!.description,
                      style: CustomTextTheme.customTextTheme()
                          .bodyLarge
                          ?.copyWith(fontSize: 52.sp),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  l10n.modules,
                  style: CustomTextTheme.customTextTheme()
                      .headlineMedium
                      ?.copyWith(fontSize: 52.sp),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            StreamBuilder<List<PRFLocalCourseModule>>(
              stream: getIt<LocalDBService>()
                  .getCourseModules(courseUlid: courseUlid),
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
                  itemBuilder: (context, index) => CourseDetailsActionCard(
                    courseModule: courseModules[index],
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsActionCard extends StatelessWidget {
  const CourseDetailsActionCard({
    required this.courseModule,
    super.key,
  });

  final PRFLocalCourseModule courseModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => context.router.push(
        ModuleDetailsRoute(courseModule: courseModule),
      ),
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 80.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppTheme.appTheme().kPrimaryColorV2.withOpacity(.1),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      courseModule.module.name!,
                      style: CustomTextTheme.customTextTheme()
                          .displayLarge
                          ?.copyWith(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
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
                          courseModule.memberModule?.percentComplete ?? 0,
                        ),
                        style: CustomTextTheme.customTextTheme().bodySmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  courseModule.module.description!,
                  style: CustomTextTheme.customTextTheme()
                      .headlineSmall
                      ?.copyWith(
                        color: AppTheme.appTheme().kBlackColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
