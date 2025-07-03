import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                        lessonModule.lesson.name!.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Icon(
                        lessonModule.lessonMember?.completionStatus?.icon ??
                            Icons.watch_later_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  lessonModule.lesson.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
