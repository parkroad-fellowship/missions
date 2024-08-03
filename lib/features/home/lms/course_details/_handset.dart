import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        title: Text(
          l10n.courseDetails,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StreamBuilder<PRFLocalCourse>(
              stream: getIt<LocalDBService>().getCourse(courseUlid: courseUlid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: StreamBuilder<PRFLocalCourse>(
                stream:
                    getIt<LocalDBService>().getCourse(courseUlid: courseUlid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final course = snapshot.data;
                  return Text(course!.name);
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.description),
                  StreamBuilder<PRFLocalCourse>(
                    stream: getIt<LocalDBService>()
                        .getCourse(courseUlid: courseUlid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final course = snapshot.data;
                      return Text(course!.description);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.modules.toUpperCase(),
                style:
                    CustomTextTheme.customTextTheme().headlineMedium!.copyWith(
                          color: AppTheme.appTheme().kAccent2BackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ),
            BlocBuilder<GetCourseModulesCubit, GetCourseModulesState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const Center(child: LinearProgressIndicator()),
                error: (message) => Center(child: Text(message)),
                loaded: SizedBox.shrink,
              ),
            ),
            StreamBuilder(
              stream: getIt<LocalDBService>()
                  .getCourseModules(courseUlid: courseUlid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final coursesModules = snapshot.data;

                if (coursesModules != null && coursesModules.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetCourseModulesCubit>()
                        .getCourseModules(courseUlid: courseUlid),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.directions_walk,
                        ),
                        Center(
                          child: Text(
                            l10n.noMissions,
                            style: CustomTextTheme.customTextTheme()
                                .headlineMedium!
                                .copyWith(
                                  color: AppTheme.appTheme().kDullGreyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: CustomTextTheme.customTextTheme()
                                    .displayLarge!
                                    .copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context
                      .read<GetCourseModulesCubit>()
                      .getCourseModules(courseUlid: courseUlid),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: coursesModules!.length,
                    itemBuilder: (context, index) {
                      final courseModule = coursesModules[index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.appTheme().kDullGreyColor,
                          size: 24,
                        ),
                        title: Text(
                          courseModule.module.name!.toUpperCase(),
                          style: CustomTextTheme.customTextTheme()
                              .headlineSmall!
                              .copyWith(
                                color:
                                    AppTheme.appTheme().kAccent2BackgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        children: [
                          ListTile(
                            dense: true,
                            minLeadingWidth: 10.5,
                            contentPadding: const EdgeInsets.only(left: 20),
                            visualDensity: VisualDensity.compact,
                            onTap: () => context.router.push(
                              ModuleDetailsRoute(
                                courseModule: coursesModules[index],
                              ),
                            ),
                            title: Text(
                              l10n.progress(
                                courseModule.memberModule?.percentComplete ?? 0,
                              ),
                              style: CustomTextTheme.customTextTheme()
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courseModule.module.description!,
                                  style: CustomTextTheme.customTextTheme()
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    },
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
