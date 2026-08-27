import 'package:app/features/events/_handset.dart';
import 'package:app/features/events/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const EventsPageTablet(),
      handset: (context) => const EventsPageHandset(),
      tablet: (context) => const EventsPageTablet(),
    );
  }
}
