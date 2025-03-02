import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/features/student_home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/home_action_card/home_action_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LandingPageTablet extends StatefulWidget {
  const LandingPageTablet({super.key});

  @override
  State<LandingPageTablet> createState() => _LandingPageTabletState();
}

class _LandingPageTabletState extends State<LandingPageTablet> {
  @override
  void initState() {
    context.read<GetClassGroupsCubit>().getClassGroups();
    context.read<GetPaymentTypesCubit>().getPaymentTypes();
    context.read<GetExpenseCategoriesCubit>().getExpenseCategories();
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    context.read<GetPrayerPromptsCubit>().getPrayerPrompts();
    context.read<UploadPrayerResponseCubit>().uploadPrayerResponses();
    context.read<GetFaqCategoriesCubit>().getFaqCategories();
    context.read<GetFaqsCubit>().getFaqs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap:
                              () => context.router.pushNamed(
                                PRFSuperAppRouter.accountRoute,
                              ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: ValueListenableBuilder(
                                valueListenable:
                                    Hive.box<dynamic>(
                                      PRFSuperAppConfig
                                          .instance!
                                          .values
                                          .hiveBox,
                                    ).listenable(),
                                builder: (context, _, _) {
                                  final profilePicture =
                                      getIt<HiveService>()
                                          .retrieveMember()
                                          ?.profilePicture;

                                  return profilePicture != null
                                      ? Image.network(
                                        profilePicture.temporaryURL,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                ),
                                      )
                                      : CircleAvatar(
                                        child: Text(
                                          Misc.getUserNameInitials(
                                            getIt<HiveService>()
                                                    .retrieveMember()
                                                    ?.fullName ??
                                                '',
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Text(
                          l10n.hello(
                            getIt<HiveService>()
                                    .retrieveProfile()
                                    ?.member
                                    ?.lastName ??
                                '',
                          ),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const Spacer(),
                        Animate(
                          effects: [
                            ShimmerEffect(duration: 1.seconds),
                            const ShakeEffect(),
                          ],
                          child: GestureDetector(
                            onTap:
                                () => context.router.pushNamed(
                                  PRFSuperAppRouter.announcementsRoute,
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.w,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Badge(
                                  child: Icon(
                                    Icons.notifications_none,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 48.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w) +
                        EdgeInsets.only(bottom: 80.h),
                    child: Text(
                      l10n.iWantTo,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.goToAMission,
                      assetPath: 'assets/svgs/missions.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.missionsRoute,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.learnSomething,
                      assetPath: 'assets/svgs/lms.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.lmsRoute,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.studentFaqs,
                      assetPath: 'assets/svgs/explore.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.memberLearnerFaqs,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.ministerToAStudent,
                      assetPath: 'assets/svgs/student_ministry.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.studentEnquiriesRoute,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.suggestAMission,
                      assetPath: 'assets/svgs/chatting.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.missionGroundSuggestionsRoute,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.give,
                      assetPath: 'assets/svgs/giving.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.givingRoute,
                          ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Animate(
                    effects: [
                      MoveEffect(
                        duration: .5.seconds,
                        curve: Curves.easeOutQuad,
                        begin: const Offset(-160, 0),
                      ),
                    ],
                    child: HomeActionCard(
                      title: l10n.registerForEvent,
                      assetPath: 'assets/svgs/events.svg',
                      onTap:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.eventsRoute,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
