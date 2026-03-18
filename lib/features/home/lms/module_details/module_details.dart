import 'package:app/features/home/lms/module_details/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ModuleDetailsPage extends StatelessWidget {
  const ModuleDetailsPage({required this.courseModuleUlid, super.key});

  final String courseModuleUlid;

  @override
  Widget build(BuildContext context) {
    return ModuleDetailsPageHandset(
      courseModuleUlid: courseModuleUlid,
    );
  }
}
