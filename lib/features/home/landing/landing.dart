import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/_tablet.dart';
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
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const LandingPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const LandingPageHandset(),
      ),
    );
  }
}
