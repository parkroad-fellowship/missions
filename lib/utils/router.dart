import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends $PRFSuperAppRouter {
  // Auth
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';

  // Landing
  static const String landingRoute = '/landing';
  static const String profileRoute = '/profile';
  static const String missionDetailsRoute = '/mission-details';
  static const String myMissionDetailsRoute = '/my-mission-details';

  // Course Work
  static const String courseDetailsRoute = '/course-details';
  static const String moduleDetailsRoute = '/module-details';

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: DecisionRoute.page, path: decisionRoute),
        AutoRoute(page: SignInRoute.page, path: signInRoute),
        AutoRoute(page: LandingRoute.page, path: landingRoute),
        AutoRoute(page: ProfileRoute.page, path: profileRoute),
        AutoRoute(page: MissionsDetailsRoute.page, path: missionDetailsRoute),
        AutoRoute(
          page: MyMissionsDetailsRoute.page,
          path: myMissionDetailsRoute,
        ),
        AutoRoute(page: CourseDetailsRoute.page, path: courseDetailsRoute),
        AutoRoute(page: ModuleDetailsRoute.page, path: moduleDetailsRoute),
      ];
}
