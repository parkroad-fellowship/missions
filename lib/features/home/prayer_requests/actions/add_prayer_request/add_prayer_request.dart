import 'package:app/features/home/prayer_requests/actions/add_prayer_request/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddPrayerRequestView extends StatelessWidget {
  const AddPrayerRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const AddPrayerRequestViewHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const AddPrayerRequestViewHandset(),
      ),
    );
  }
}
