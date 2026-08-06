import 'package:app/features/home/faqs/_handset.dart';
import 'package:app/features/home/faqs/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class MemberFAQPage extends StatelessWidget {
  const MemberFAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const MemberFAQPageHandset(),
      handset: (context) => const MemberFAQPageHandset(),
      tablet: (context) => const MemberFAQPageTablet(),
    );
  }
}
