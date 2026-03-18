import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_type_resource_cubit.dart';
import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
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

    context.read<ClassGroupResourceCubit>().loadAll();
    context.read<PaymentTypeResourceCubit>().loadAll();
    context.read<ExpenseCategoryResourceCubit>().loadAll();
    context.read<AnnouncementResourceCubit>().loadAll();
    context.read<GetPrayerPromptsCubit>().getPrayerPrompts();
    context.read<UploadPrayerResponseCubit>().uploadPrayerResponses();
    context.read<FaqCategoryResourceCubit>().loadAll();
    context.read<FaqResourceCubit>().loadAll();

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
      // Faith & Ministry
      LandingActionItem(
        title: l10n.goToAMission,
        assetPath: 'assets/svgs/missions.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.missionsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
      ),
      LandingActionItem(
        title: l10n.ministerToAStudent,
        assetPath: 'assets/svgs/student_ministry.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.studentEnquiriesRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
      ),
      LandingActionItem(
        title: l10n.suggestAMission,
        assetPath: 'assets/svgs/chatting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.missionGroundSuggestionsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
      ),

      // Learn & Grow
      LandingActionItem(
        title: l10n.learnSomething,
        assetPath: 'assets/svgs/lms.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.lmsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Learn & Grow',
      ),
      LandingActionItem(
        title: l10n.studentFaqs,
        assetPath: 'assets/svgs/explore.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.memberLearnerFaqs,
        ),
        animationDelay: 0,
        deskGroup: 'Learn & Grow',
      ),

      // Community
      LandingActionItem(
        title: l10n.registerForEvent,
        assetPath: 'assets/svgs/events.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.eventsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Community',
      ),
      LandingActionItem(
        title: l10n.submitPrayerRequest,
        assetPath: 'assets/svgs/texting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.prayerRequestRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Community',
      ),
      LandingActionItem(
        title: l10n.give,
        assetPath: 'assets/svgs/giving.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.givingRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
      ),

      // Extras
      LandingActionItem(
        title: l10n.wrapped,
        assetPath: 'assets/svgs/wrapped.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.wrappedRoute,
        ),
        animationDelay: 0,
        isNeutralCard: true,
        deskGroup: 'Extras',
      ),
    ];

    return LandingPageHandset(actions: actions);
  }
}
