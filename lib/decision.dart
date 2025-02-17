import 'package:app/enums/prf_roles.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

@RoutePage()
class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  @override
  void initState() {
    super.initState();
    final accessToken = getIt<HiveService>().retrieveToken();

    if (accessToken == null) {
      _redirectToPage(context, PRFSuperAppRouter.signInRoute);
      return;
    }

    final profile = getIt<HiveService>().retrieveProfile()!;

    /// If both the member and student are null, then the user is lacking a
    /// profile and should be redirected to the sign-in page.
    if (profile.member == null && profile.student == null) {
      _redirectToPage(context, PRFSuperAppRouter.signInRoute);
      return;
    }

    final result = profile.roles.where(
      (role) => role.name == PrfRole.student.label,
    );

    if (result.isEmpty) {
      _redirectToPage(context, PRFSuperAppRouter.landingRoute);
      return;
    } else {
      _redirectToPage(context, PRFSuperAppRouter.studentLandingRoute);
      return;
    }
  }

  void _redirectToPage(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.router.pushNamed(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: UpgradeAlert(
        child: Scaffold(
          body: Center(
            child: ExtendedImage.asset(
              'assets/images/app-logo.png',
              width: 222,
              cacheRawData: true,
            ),
          ),
        ),
      ),
    );
  }
}
