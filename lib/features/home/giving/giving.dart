import 'package:app/features/home/giving/_handset.dart';
import 'package:app/features/home/giving/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class GivingPage extends StatelessWidget {
  const GivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const GivingPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const GivingPageHandset(),
      ),
    );
  }
}
