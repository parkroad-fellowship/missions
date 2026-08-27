import 'package:app/features/lms/module_details/_handset.dart';
import 'package:app/features/lms/module_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class ModuleDetailsPage extends StatelessWidget {
  const ModuleDetailsPage({required this.courseModuleUlid, super.key});

  final String courseModuleUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => ModuleDetailsPageTablet(
        courseModuleUlid: courseModuleUlid,
      ),
      handset: (context) => ModuleDetailsPageHandset(
        courseModuleUlid: courseModuleUlid,
      ),
      tablet: (context) => ModuleDetailsPageTablet(
        courseModuleUlid: courseModuleUlid,
      ),
    );
  }
}
