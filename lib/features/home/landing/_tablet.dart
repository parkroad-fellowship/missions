import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/home_action_card/home_action_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

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
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      // Profile Picture
                      GestureDetector(
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.accountRoute,
                        ),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: ValueListenableBuilder(
                              valueListenable: Hive.box<dynamic>(
                                PRFSuperAppConfig.instance!.values.hiveBox,
                              ).listenable(),
                              builder: (context, _, _) {
                                final profilePicture = getIt<HiveService>()
                                    .retrieveMember()
                                    ?.profilePicture;

                                return profilePicture != null
                                    ? Image.network(
                                        profilePicture.temporaryURL,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                CircleAvatar(
                                                  backgroundColor: theme
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 32,
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        child: Text(
                                          Misc.getUserNameInitials(
                                            getIt<HiveService>()
                                                    .retrieveMember()
                                                    ?.fullName ??
                                                '',
                                          ),
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        duration: 2000.ms,
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.05, 1.05),
                      )
                      .then(delay: 1000.ms),

                      const SizedBox(width: 24),

                      // Greeting Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.welcome,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.hello(
                                getIt<HiveService>().auth
                                        .retrieveProfile()
                                        ?.member
                                        ?.lastName ??
                                    '',
                              ),
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.router.pushNamed(
                            PRFSuperAppRouter.announcementsRoute,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: theme.colorScheme.onSurface,
                                    size: 28,
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.iWantTo,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          fontSize: 48,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 80,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action Cards
              SliverPadding(
                padding: EdgeInsets.zero,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.goToAMission,
                        assetPath: 'assets/svgs/missions.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.missionsRoute,
                        ),
                      ),
                      delay: 0,
                      slideDirection: -1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.learnSomething,
                        assetPath: 'assets/svgs/lms.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.lmsRoute,
                        ),
                      ),
                      delay: 100,
                      slideDirection: 1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.studentFaqs,
                        assetPath: 'assets/svgs/explore.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.memberLearnerFaqs,
                        ),
                      ),
                      delay: 200,
                      slideDirection: -1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.ministerToAStudent,
                        assetPath: 'assets/svgs/student_ministry.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.studentEnquiriesRoute,
                        ),
                      ),
                      delay: 300,
                      slideDirection: 1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.suggestAMission,
                        assetPath: 'assets/svgs/chatting.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.missionGroundSuggestionsRoute,
                        ),
                      ),
                      delay: 400,
                      slideDirection: -1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.registerForEvent,
                        assetPath: 'assets/svgs/events.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.eventsRoute,
                        ),
                      ),
                      delay: 500,
                      slideDirection: 1,
                    ),

                    _buildAnimatedCard(
                      child: HomeActionCard(
                        title: l10n.submitPrayerRequest,
                        assetPath: 'assets/svgs/texting.svg',
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.prayerRequestRoute,
                        ),
                      ),
                      delay: 600,
                      slideDirection: -1,
                    ),

                    const SizedBox(height: 60),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required Widget child,
    required int delay,
    required int slideDirection,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Animate(
        effects: [
          FadeEffect(
            duration: 400.ms,
            delay: Duration(milliseconds: delay),
          ),
          SlideEffect(
            duration: 500.ms,
            delay: Duration(milliseconds: delay),
            begin: Offset(slideDirection * 0.2, 0),
            curve: Curves.easeOut,
          ),
        ],
        child: child,
      ),
    );
  }
}
