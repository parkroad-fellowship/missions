import 'package:app/features/home/lms/module_details/_handset.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class ModuleDetailsPage extends StatelessWidget {
  const ModuleDetailsPage({
    required this.module,
    super.key,
  });

  final PRFLocalModule module;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => ModuleDetailsPageHandset(module: module),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => ModuleDetailsPageHandset(module: module),
      ),
    );
  }
}
