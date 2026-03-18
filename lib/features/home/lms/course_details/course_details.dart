import 'package:app/features/home/lms/course_details/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({required this.courseUlid, super.key});

  final String courseUlid;

  @override
  Widget build(BuildContext context) {
    return CourseDetailsPageHandset(courseUlid: courseUlid);
  }
}
