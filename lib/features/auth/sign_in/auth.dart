import 'package:app/features/auth/sign_in/_handset.dart';
import 'package:app/features/auth/sign_in/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const SignInTablet(),
      handset: (context) => const SignInHandset(),
      tablet: (context) => const SignInTablet(),
    );
  }
}
