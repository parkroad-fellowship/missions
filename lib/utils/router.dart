import 'package:app/decision.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/home/landing.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends $PRFSuperAppRouter {
  static const String decisionRoute = '/';
  static const String authRoute = '/auth';
  static const String landingPage = '/landing';

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: DecisionRoute.page, path: decisionRoute),
        AutoRoute(page: AuthRoute.page, path: authRoute),
        AutoRoute(page: LandingRoute.page, path: landingPage),
      ];
}
