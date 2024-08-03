import 'package:app/features/student_home/faqs/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class FAQPage extends StatelessWidget {
  const FAQPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const FAQPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const FAQPageHandset(),
      ),
    );
  }
}
