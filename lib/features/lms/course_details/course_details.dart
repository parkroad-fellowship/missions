import 'package:app/di/di_container.dart';
import 'package:app/features/lms/course_details/_handset.dart';
import 'package:app/features/lms/course_details/_tablet.dart';
import 'package:app/features/lms/course_details/cubit/course_details_resource_cubit.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({required this.courseUlid, super.key});

  final String courseUlid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseDetailsResourceCubit>(
      create: (context) => CourseDetailsResourceCubit(
        courseService: getIt<CourseService>(),
        hiveService: getIt<HiveService>(),
      )..loadCourse(courseUlid: courseUlid),
      child: PRFAdaptive(
        builder: (context, _) =>
            CourseDetailsPageHandset(courseUlid: courseUlid),
        handset: (context) => CourseDetailsPageHandset(courseUlid: courseUlid),
        tablet: (context) => CourseDetailsPageTablet(courseUlid: courseUlid),
      ),
    );
  }
}
