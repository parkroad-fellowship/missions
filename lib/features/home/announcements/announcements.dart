import 'package:app/features/home/announcements/_handset.dart';
import 'package:app/features/home/announcements/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const AnnouncementsPageHandset(),
      handset: (context) => const AnnouncementsPageHandset(),
      tablet: (context) => const AnnouncementsPageTablet(),
    );
  }
}
