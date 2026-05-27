import 'package:app/features/lms/course_details/_handset.dart';
import 'package:app/features/lms/course_details/cubit/course_details_resource_cubit.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({required this.courseUlid, super.key});

  final String courseUlid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseDetailsResourceCubit>(
      create: (context) => CourseDetailsResourceCubit(
        courseService: GetIt.instance(),
        dbService: GetIt.instance<IsarService>().courses,
      )..loadCourse(courseUlid: courseUlid),
      child: CourseDetailsPageHandset(courseUlid: courseUlid),
    );
  }
}
