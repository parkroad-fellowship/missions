import 'package:app/utils/router.gr.dart';
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

  // Course Work
  static const String courseDetailsRoute = '/course-details';
  static const String moduleDetailsRoute = '/module-details';
  static const String lessonDetailsRoute = '/lesson-details';

  @override
  List<AutoRoute> get routes => [
    // Auth
    AutoRoute(page: DecisionRoute.page, path: decisionRoute),
    AutoRoute(page: SignInRoute.page, path: signInRoute),

    // Landing
    AutoRoute(page: MissionsRoute.page, path: missionsRoute),
    AutoRoute(page: LMSRoute.page, path: lmsRoute),
    AutoRoute(page: StudentEnquiriesRoute.page, path: studentEnquiriesRoute),
    AutoRoute(page: AccountRoute.page, path: accountRoute),
    AutoRoute(page: AnnouncementsRoute.page, path: announcementsRoute),
    AutoRoute(page: LandingRoute.page, path: landingRoute),
    AutoRoute(page: MissionsDetailsRoute.page, path: missionDetailsRoute),
    AutoRoute(page: StudentEnquiryRepliesRoute.page, path: repliesRoute),
    AutoRoute(page: MemberFAQRoute.page, path: memberLearnerFaqs),
    AutoRoute(
      page: MissionGroundSuggestionsRoute.page,
      path: missionGroundSuggestionsRoute,
    ),
    AutoRoute(page: GivingRoute.page, path: givingRoute),
    AutoRoute(page: SessionRoute.page, path: missionSessionRoute),
    AutoRoute(page: EventsRoute.page, path: eventsRoute),
    AutoRoute(page: EventDetailsRoute.page, path: eventDetailsRoute),

    // Course Work
    AutoRoute(page: CourseDetailsRoute.page, path: courseDetailsRoute),
    AutoRoute(page: ModuleDetailsRoute.page, path: moduleDetailsRoute),
    AutoRoute(page: LessonDetailsRoute.page, path: lessonDetailsRoute),
  ];
}
