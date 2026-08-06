import 'package:app/features/home/prayer_requests/_handset.dart';
import 'package:app/features/home/prayer_requests/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class PrayerRequest extends StatelessWidget {
  const PrayerRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const PrayerRequestHandset(),
      handset: (context) => const PrayerRequestHandset(),
      tablet: (context) => const PrayerRequestTablet(),
    );
  }
}
