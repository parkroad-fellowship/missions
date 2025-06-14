import 'package:app/features/home/prayer_requests/_handset.dart';
import 'package:app/features/home/prayer_requests/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class PrayerRequest extends StatelessWidget {
  const PrayerRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const PrayerRequestTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const PrayerRequestHandset(),
      ),
    );
  }
}
