import 'package:app/decision.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/home/landing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PRFSuperAppRouter {
  static GoRouter get router => _router;

  static const String decisionRoute = '/';
  static const String authRoute = '/auth';
  static const String landingPage = '/landing';

  static final GlobalKey<NavigatorState> _globalNavigatorKey =
      GlobalKey<NavigatorState>();
  static final _router = GoRouter(
    initialLocation: decisionRoute,
    navigatorKey: _globalNavigatorKey,
    routes: [
      GoRoute(
        path: decisionRoute,
        name: decisionRoute,
        builder: (context, state) => const DecisionPage(),
      ),
      GoRoute(
        path: authRoute,
        name: authRoute,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: landingPage,
        name: landingPage,
        builder: (context, state) => const LandingPage(),
      ),
    ],
  );
}
