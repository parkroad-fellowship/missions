import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        onTap: () => context.router.push(
          CourseDetailsRoute(courseUlid: course.ulid),
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
                ).colorScheme.secondary.withValues(alpha: .3),
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
