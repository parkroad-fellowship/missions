import 'package:app/features/home/giving/_handset.dart';
import 'package:app/features/home/giving/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class GivingPage extends StatelessWidget {
  const GivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const GivingPageHandset(),
      handset: (context) => const GivingPageHandset(),
      tablet: (context) => const GivingPageTablet(),
    );
  }
}
