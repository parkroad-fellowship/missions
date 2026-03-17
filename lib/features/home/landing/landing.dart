import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/_tablet.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/features/home/shared/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
      await getIt<FirebaseMessagingService>().init();
    } catch (e) {
      Logger().e('NotificationService init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final actions = <LandingActionItem>[
      LandingActionItem(
        title: l10n.goToAMission,
        assetPath: 'assets/svgs/missions.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.missionsRoute,
        ),
        animationDelay: 0,
      ),
      LandingActionItem(
        title: l10n.learnSomething,
        assetPath: 'assets/svgs/lms.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.lmsRoute,
        ),
        animationDelay: 100,
      ),
      LandingActionItem(
        title: l10n.studentFaqs,
        assetPath: 'assets/svgs/explore.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.memberLearnerFaqs,
        ),
        animationDelay: 200,
      ),
      LandingActionItem(
        title: l10n.ministerToAStudent,
        assetPath: 'assets/svgs/student_ministry.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.studentEnquiriesRoute,
        ),
        animationDelay: 300,
      ),
      LandingActionItem(
        title: l10n.suggestAMission,
        assetPath: 'assets/svgs/chatting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.missionGroundSuggestionsRoute,
        ),
        animationDelay: 400,
      ),
      LandingActionItem(
        title: l10n.registerForEvent,
        assetPath: 'assets/svgs/events.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.eventsRoute,
        ),
        animationDelay: 500,
      ),
      LandingActionItem(
        title: l10n.submitPrayerRequest,
        assetPath: 'assets/svgs/texting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.prayerRequestRoute,
        ),
        animationDelay: 600,
      ),
      LandingActionItem(
        title: l10n.give,
        assetPath: 'assets/svgs/giving.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.givingRoute,
        ),
        animationDelay: 700,
      ),
      LandingActionItem(
        title: l10n.wrapped,
        assetPath: 'assets/svgs/wrapped.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.wrappedRoute,
        ),
        animationDelay: 0,
      ),
    ];

    return AdaptiveBuilder(
      defaultBuilder: (_, _) => LandingPageTablet(actions: actions),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => LandingPageHandset(actions: actions),
        tablet: (_, _) => LandingPageTablet(actions: actions),
      ),
    );
  }
}
