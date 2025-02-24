import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class PRFSuperAppRouter extends RootStackRouter {
  // Auth
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String registerStudentRoute = '/register-student';

  // Landing
  static const String missionsRoute = '/missions';
  static const String missionDetailsRoute = '/mission-details/:missionUlid';
  
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
  static const String missionSessionRoute = '/mission-session';
  static const String eventsRoute = '/events';
  static const String eventDetailsRoute = '/event-details';

  // Student Landing
  static const String studentLandingRoute = '/student-landing';
  static const String learnerEnquiriesRoute = '/learner-enquiries';
  static const String learnerFaqs = '/learner-faqs';
  static const String studentAccountRoute = '/student-account';
  static const String studentRepliesRoute = '/student-replies';
  static const String createStudentEnquiryRoute = '/create-student-enquiry';

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

    // Student Landing
    AutoRoute(page: StudentLandingRoute.page, path: studentLandingRoute),
    AutoRoute(page: LearnerEnquiriesRoute.page, path: learnerEnquiriesRoute),
    AutoRoute(page: FAQRoute.page, path: learnerFaqs),
    AutoRoute(page: StudentAccountRoute.page, path: studentAccountRoute),
    AutoRoute(page: EnquiryRepliesRoute.page, path: studentRepliesRoute),
    AutoRoute(page: CreateEnquiryRoute.page, path: createStudentEnquiryRoute),

    // Course Work
    AutoRoute(page: CourseDetailsRoute.page, path: courseDetailsRoute),
    AutoRoute(page: ModuleDetailsRoute.page, path: moduleDetailsRoute),
    AutoRoute(page: LessonDetailsRoute.page, path: lessonDetailsRoute),
  ];
}
