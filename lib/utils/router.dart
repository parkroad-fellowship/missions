import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends $PRFSuperAppRouter {
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String landingRoute = '/landing';
  static const String profileRoute = '/profile';

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: DecisionRoute.page, path: decisionRoute),
        AutoRoute(page: SignInRoute.page, path: signInRoute),
        AutoRoute(page: LandingRoute.page, path: landingRoute),
        AutoRoute(page: ProfileRoute.page, path: profileRoute),
      ];
}
