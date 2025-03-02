import 'package:app/features/home/faqs/_handset.dart';
import 'package:app/features/home/faqs/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class MemberFAQPage extends StatelessWidget {
  const MemberFAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const MemberFAQPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const MemberFAQPageHandset(),
      ),
    );
  }
}
