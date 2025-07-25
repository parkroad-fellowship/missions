import 'package:app/features/home/lms/module_details/_handset.dart';
import 'package:app/features/home/lms/module_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class ModuleDetailsPage extends StatelessWidget {
  const ModuleDetailsPage({required this.courseModuleUlid, super.key});

  final String courseModuleUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => ModuleDetailsPageTablet(
        courseModuleUlid: courseModuleUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => ModuleDetailsPageHandset(
          courseModuleUlid: courseModuleUlid,
        ),
      ),
    );
  }
}
