import 'package:app/enums/prf_completion_status.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ModuleDetailsPageHandset extends StatefulWidget {
  const ModuleDetailsPageHandset({
    required this.courseModule,
    super.key,
  });

  final PRFLocalCourseModule courseModule;

  @override
  State<ModuleDetailsPageHandset> createState() =>
      _ModuleDetailsPageHandsetState();
}

class _ModuleDetailsPageHandsetState extends State<ModuleDetailsPageHandset> {
  PRFLocalCourseModule get courseModule => widget.courseModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final module = courseModule.module;

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
            child: Text(
              l10n.percentage(
                module.memberModule?.percentComplete?.toInt() ?? 0,
              ),
              style: CustomTextTheme.customTextTheme()
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
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
              title: Text(module.name!.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.description),
                  Text(module.description!),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: module.lessonModules!.length,
              itemBuilder: (context, index) {
                final lesson = module.lessonModules![index].lesson!;
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
                          color: AppTheme.appTheme().kAccent2BackgroundColor,
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
                          lessonModule: module.lessonModules![index],
                          courseUlid: courseModule.courseUlid,
                          moduleUlid: courseModule.module.ulid!,
                        ),
                      ),
                      title: Text(
                        PRFCompletionStatusExtension.fromIndex(
                          lesson.lessonMember?.completionStatus ?? 0,
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
            ),
          ],
        ),
      ),
    );
  }
}
