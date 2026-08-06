import 'package:app/features/home/account/_handset.dart';
import 'package:app/features/home/account/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const AccountPageHandset(),
      handset: (context) => const AccountPageHandset(),
      tablet: (context) => const AccountPageTablet(),
    );
  }
}
