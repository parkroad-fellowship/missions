import 'package:app/features/home/lms/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class LMSPage extends StatelessWidget {
  const LMSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const LMSPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const LMSPageHandset(),
      ),
    );
  }
}
