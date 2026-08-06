import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/_tablet.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
        title: l10n.suggestAMission,
        assetPath: 'assets/svgs/chatting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.missionGroundSuggestionsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
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
      LandingActionItem(
        title: l10n.answerFaqs,
        assetPath: 'assets/svgs/recording.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.answerFAQsRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Faith & Ministry',
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
        title: l10n.submitPrayerRequest,
        assetPath: 'assets/svgs/texting.svg',
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.prayerRequestRoute,
        ),
        animationDelay: 0,
        deskGroup: 'Community',
      ),
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

    return PRFAdaptive(
      builder: (context, _) => LandingPageTablet(actions: actions),
      handset: (context) => LandingPageHandset(actions: actions),
      tablet: (context) => LandingPageTablet(actions: actions),
    );
  }
}
