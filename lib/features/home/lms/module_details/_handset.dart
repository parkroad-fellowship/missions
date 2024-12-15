import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModuleDetailsPageHandset extends StatefulWidget {
  const ModuleDetailsPageHandset({
    required this.courseModuleUlid,
    required this.moduleUlid,
    required this.courseUlid,
    super.key,
  });

  final String courseModuleUlid;
  final String moduleUlid;
  final String courseUlid;

  @override
  State<ModuleDetailsPageHandset> createState() =>
      _ModuleDetailsPageHandsetState();
}

class _ModuleDetailsPageHandsetState extends State<ModuleDetailsPageHandset> {
  String get courseModuleUlid => widget.courseModuleUlid;

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
                          PRFSuperAppRouter.courseDetailsRoute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 0.5.sw,
                      child: Text(
                        l10n.moduleDetails,
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: StreamBuilder<PRFLocalCourseModule>(
                        stream: getIt<LocalDBService>().getCourseModule(
                          courseModuleUlid: courseModuleUlid,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final courseModule = snapshot.data!;
                          return Text(
                            l10n.percentage(
                              courseModule.memberModule?.percentComplete
                                      ?.toInt() ??
                                  0,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: StreamBuilder<PRFLocalCourseModule>(
                  stream: getIt<LocalDBService>()
                      .getCourseModule(courseModuleUlid: courseModuleUlid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final courseModule = snapshot.data!;
                    return Text(
                      courseModule.module.name!,
                      style: CustomTextTheme.customTextTheme()
                          .headlineMedium
                          ?.copyWith(fontSize: 52.sp),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<PRFLocalCourseModule>(
                stream: getIt<LocalDBService>().getCourseModule(
                  courseModuleUlid: courseModuleUlid,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final course = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      course!.module.description!,
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
                  l10n.lessons,
                  style: CustomTextTheme.customTextTheme()
                      .headlineMedium
                      ?.copyWith(fontSize: 52.sp),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            StreamBuilder<List<PRFLocalLessonModule>>(
              stream: getIt<LocalDBService>().getLessonModules(
                moduleUlid: widget.moduleUlid,
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
                  itemBuilder: (context, index) => ModuleDetailsActionCard(
                    lessonModule: courseModules[index],
                    courseUlid: widget.courseUlid,
                    moduleUlid: widget.moduleUlid,
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

class ModuleDetailsActionCard extends StatelessWidget {
  const ModuleDetailsActionCard({
    required this.lessonModule,
    required this.courseUlid,
    required this.moduleUlid,
    super.key,
  });

  final PRFLocalLessonModule lessonModule;
  final String courseUlid;
  final String moduleUlid;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => context.router.push(
        LessonDetailsRoute(
          lessonModule: lessonModule,
          courseUlid: courseUlid,
          moduleUlid: moduleUlid,
        ),
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
              color:
                  AppTheme.appTheme().kPrimaryColorV2.withValues(alpha: width),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lessonModule.lesson.name!,
                      style: CustomTextTheme.customTextTheme()
                          .displayLarge
                          ?.copyWith(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 4.h,
                      ),
                      child: Icon(
                        lessonModule.lessonMember?.completionStatus?.icon,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  lessonModule.lesson.description!,
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall?.copyWith(
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
