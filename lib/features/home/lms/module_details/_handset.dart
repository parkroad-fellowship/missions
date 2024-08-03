import 'package:app/enums/prf_completion_status.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(
          l10n.moduleDetails,
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
            child: StreamBuilder<PRFLocalCourseModule>(
              stream: getIt<LocalDBService>()
                  .getCourseModule(courseModuleUlid: courseModuleUlid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                final courseModule = snapshot.data!;

                return Text(
                  l10n.percentage(
                    courseModule.memberModule?.percentComplete ?? 0,
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
              title: StreamBuilder<PRFLocalCourseModule>(
                stream: getIt<LocalDBService>().getCourseModule(
                  courseModuleUlid: courseModuleUlid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  final module = snapshot.data!.module;
                  return Text(module.name!.toUpperCase());
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.description),
                  StreamBuilder<PRFLocalCourseModule>(
                    stream: getIt<LocalDBService>().getCourseModule(
                      courseModuleUlid: courseModuleUlid,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      final module = snapshot.data!.module;
                      return Text(module.description!);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.lessons.toUpperCase(),
                style:
                    CustomTextTheme.customTextTheme().headlineMedium!.copyWith(
                          color: AppTheme.appTheme().kAccent2BackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ),
            StreamBuilder<List<PRFLocalLessonModule>>(
              stream: getIt<LocalDBService>().getLessonModules(
                moduleUlid: widget.moduleUlid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                final lessonModules = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: lessonModules.length,
                  itemBuilder: (context, index) {
                    final lesson = lessonModules[index].lesson;
                    return ExpansionTile(
                      initiallyExpanded: true,
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppTheme.appTheme().kDullGreyColor,
                        size: 24,
                      ),
                      title: Text(
                        lesson.name!.toUpperCase(),
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
                            LessonDetailsRoute(
                              lessonModule: lessonModules[index],
                              courseUlid: widget.courseUlid,
                              moduleUlid: widget.moduleUlid,
                            ),
                          ),
                          title: Text(
                            PRFCompletionStatusExtension.fromIndex(
                              lessonModules[index]
                                      .lessonMember
                                      ?.completionStatus ??
                                  0,
                            ).name,
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
                                lesson.description!,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
