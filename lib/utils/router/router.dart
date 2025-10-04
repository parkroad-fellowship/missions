import 'package:app/utils/router/guards/auth_guard.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends RootStackRouter {
  // Auth
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';

  // Landing
  static const String missionsRoute = '/missions';
  static const String missionDetailsRoute = '/mission-details/:missionUlid';
  static const String missionSessionRoute =
      '/mission-details/:missionUlid/mission-sessions/:missionSessionUlid/:missionSessionId';

  static const String lmsRoute = '/lms';
  static const String studentEnquiriesRoute = '/student-enquiries';
  static const String memberLearnerFaqs = '/member-learner-faqs';
  static const String accountRoute = '/account';
  static const String announcementsRoute = '/announcements';
  static const String landingRoute = '/landing';

  static const String myMissionDetailsRoute = '/my-mission-details';
  static const String repliesRoute = '/replies';
  static const String missionGroundSuggestionsRoute =
      '/mission-ground-suggestions';
  static const String givingRoute = '/giving';

  static const String eventsRoute = '/events';
  static const String eventDetailsRoute = '/event-details';

  static const String prayerRequestRoute = '/prayer-requests';

  // Course Work
  static const String courseDetailsRoute = '/course-details';
  static const String moduleDetailsRoute = '/module-details';
  static const String lessonDetailsRoute = '/lesson-details';

  // Wrapped
  static const String wrappedRoute = '/wrapped';

  @override
  List<AutoRoute> get routes => [
    // Auth
    CustomRoute<dynamic>(
      page: DecisionRoute.page,
      path: decisionRoute,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute<dynamic>(
      page: SignInRoute.page,
      path: signInRoute,
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),

    // Landing
    CustomRoute<dynamic>(
      page: PrayerRequest.page,
      path: prayerRequestRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: MissionsRoute.page,
      path: missionsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: LMSRoute.page,
      path: lmsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: StudentEnquiriesRoute.page,
      path: studentEnquiriesRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: AccountRoute.page,
      path: accountRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: AnnouncementsRoute.page,
      path: announcementsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: LandingRoute.page,
      path: landingRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: MissionsDetailsRoute.page,
      path: missionDetailsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute<dynamic>(
      page: StudentEnquiryRepliesRoute.page,
      path: repliesRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute<dynamic>(
      page: MemberFAQRoute.page,
      path: memberLearnerFaqs,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: MissionGroundSuggestionsRoute.page,
      path: missionGroundSuggestionsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: GivingRoute.page,
      path: givingRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: SessionRoute.page,
      path: missionSessionRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute<dynamic>(
      page: EventsRoute.page,
      path: eventsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute<dynamic>(
      page: EventDetailsRoute.page,
      path: eventDetailsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),

    // Course Work
    CustomRoute<dynamic>(
      page: CourseDetailsRoute.page,
      path: courseDetailsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute<dynamic>(
      page: ModuleDetailsRoute.page,
      path: moduleDetailsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute<dynamic>(
      page: LessonDetailsRoute.page,
      path: lessonDetailsRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    // Wrapped
    CustomRoute<dynamic>(
      page: MissionsWrappedRoute.page,
      path: wrappedRoute,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
  ];
}
