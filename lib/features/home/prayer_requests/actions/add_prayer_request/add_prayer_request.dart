import 'package:app/features/home/prayer_requests/actions/add_prayer_request/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddPrayerRequestView extends StatelessWidget {
  const AddPrayerRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => const AddPrayerRequestViewHandset(),
      builder: (_, _) => const AddPrayerRequestViewHandset(),
    );
  }
}
