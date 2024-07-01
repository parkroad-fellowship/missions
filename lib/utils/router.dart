import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends $PRFSuperAppRouter {
  // Auth
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String registerStudentRoute = '/register-student';

  // Landing
  static const String landingRoute = '/landing';
  static const String profileRoute = '/profile';
  static const String missionDetailsRoute = '/mission-details';
  static const String myMissionDetailsRoute = '/my-mission-details';

  // Student Landing
  static const String studentLandingRoute = '/student-landing';
  static const String studentProfileRoute = '/student-profile';

  // Course Work
  static const String courseDetailsRoute = '/course-details';
  static const String moduleDetailsRoute = '/module-details';
  static const String lessonDetailsRoute = '/lesson-details';

  @override
  List<AutoRoute> get routes => [
        // Auth
        AutoRoute(page: DecisionRoute.page, path: decisionRoute),
        AutoRoute(page: SignInRoute.page, path: signInRoute),
        AutoRoute(page: StudentIntroRoute.page, path: registerStudentRoute),

        // Landing
        AutoRoute(page: LandingRoute.page, path: landingRoute),
        AutoRoute(page: ProfileRoute.page, path: profileRoute),
        AutoRoute(page: MissionsDetailsRoute.page, path: missionDetailsRoute),

        // Student Landing
        AutoRoute(page: StudentLandingRoute.page, path: studentLandingRoute),
        AutoRoute(page: StudentProfileRoute.page, path: studentProfileRoute),

        // Course Work
        AutoRoute(
          page: MyMissionsDetailsRoute.page,
          path: myMissionDetailsRoute,
        ),
        AutoRoute(page: CourseDetailsRoute.page, path: courseDetailsRoute),
        AutoRoute(page: ModuleDetailsRoute.page, path: moduleDetailsRoute),
        AutoRoute(page: LessonDetailsRoute.page, path: lessonDetailsRoute),
      ];
}
