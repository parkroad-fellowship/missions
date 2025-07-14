import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/_tablet.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:logger/logger.dart';
import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    context.read<GetClassGroupsCubit>().getClassGroups();
    context.read<GetPaymentTypesCubit>().getPaymentTypes();
    context.read<GetExpenseCategoriesCubit>().getExpenseCategories();
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    context.read<GetPrayerPromptsCubit>().getPrayerPrompts();
    context.read<UploadPrayerResponseCubit>().uploadPrayerResponses();
    context.read<GetFaqCategoriesCubit>().getFaqCategories();
    context.read<GetFaqsCubit>().getFaqs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      await getIt<NotificationService>().requestPermissions();
      await getIt<NotificationService>().init();

      await getIt<NotificationService>().scheduleGivingNotification();
    } catch (e) {
      Logger().e('NotificationService init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final actions = [
      [
        l10n.goToAMission,
        'assets/svgs/missions.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.missionsRoute,
        ),
        0,
      ],
      [
        l10n.learnSomething,
        'assets/svgs/lms.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.lmsRoute,
        ),
        100,
      ],
      [
        l10n.studentFaqs,
        'assets/svgs/explore.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.memberLearnerFaqs,
        ),
        200,
      ],
      [
        l10n.ministerToAStudent,
        'assets/svgs/student_ministry.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.studentEnquiriesRoute,
        ),
        300,
      ],
      [
        l10n.suggestAMission,
        'assets/svgs/chatting.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.missionGroundSuggestionsRoute,
        ),
        400,
      ],
      [
        l10n.registerForEvent,
        'assets/svgs/events.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.eventsRoute,
        ),
        500,
      ],
      [
        l10n.submitPrayerRequest,
        'assets/svgs/texting.svg',
        () => context.router.pushNamed(
          PRFSuperAppRouter.prayerRequestRoute,
        ),
        600,
      ],
    ];

    return AdaptiveBuilder(
      defaultBuilder: (_, _) =>  LandingPageTablet(actions: actions),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) =>  LandingPageHandset(actions: actions),
        tablet: (_, _) =>  LandingPageTablet(actions: actions),
      ),
    );
  }
}
