import 'package:app/features/home/my_missions/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MyMissionsPage extends StatelessWidget {
  const MyMissionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const MyMissionsPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const MyMissionsPageHandset(),
      ),
    );
  }
}
