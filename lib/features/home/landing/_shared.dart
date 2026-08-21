import 'package:app/di/di_container.dart';
import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_type_resource_cubit.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/features/home/landing/widgets/landing_action_tile.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/services/firebase/firebase_messaging_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

class LandingState {
  LandingState();

  late final VoidCallback _rebuild;

  /// Whether the card entrance cascade has already played for this screen
  /// instance; later rebuilds and scrolled-in cards skip the animation.
  bool entrancePlayed = false;

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  /// Prefetches all required cubits for the landing dashboard
  Future<void> prefetch(BuildContext context) async {
    try {
      await Future.wait([
        context.read<PaymentTypeResourceCubit>().loadAll(),
        context.read<AnnouncementResourceCubit>().loadAll(),
        context.read<GetPrayerPromptsCubit>().getPrayerPrompts(),
        context.read<UploadPrayerResponseCubit>().uploadPrayerResponses(),
        context.read<FaqCategoryResourceCubit>().loadAll(),
        context.read<FaqResourceCubit>().loadAll(),
        context.read<ExpenseCategoryResourceCubit>().loadAll(),
      ]);
      _rebuild();
    } catch (e) {
      Logger().e('LandingState prefetch error: $e');
    }
  }

  /// Requests OS permissions and initializes notifications
  Future<void> initializeNotifications() async {
    try {
      await getIt<NotificationService>().requestPermissions();
      await getIt<NotificationService>().init();
      await getIt<FirebaseMessagingService>().init();
    } catch (e) {
      Logger().e('NotificationService init error: $e');
    }
  }

  void dispose() {
    // No controllers to dispose for landing, but kept for signature consistency
  }
}

Widget buildProfilePicture(
  BuildContext context,
  ThemeData theme,
  double size, {
  Color? ringColor,
  String? semanticsLabel,
}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  final effectiveRingColor = ringColor ?? theme.colorScheme.primary;

  Widget avatar = GestureDetector(
    onTap: () => context.router.pushPath(
      PRFSuperAppRouter.accountRoute,
    ),
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveRingColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveRingColor.withValues(alpha: 0.3),
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
                    errorBuilder: (context, error, stackTrace) => CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      StringFormatter.getUserNameInitials(
                        getIt<HiveService>().retrieveMember()?.fullName ?? '',
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: PRFColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
          },
        ),
      ),
    ),
  );

  avatar = Semantics(
    button: true,
    label: semanticsLabel,
    child: avatar,
  );

  if (reduceMotion) {
    return avatar;
  }

  return avatar
      .animate(onPlay: (controller) => controller.repeat(reverse: true))
      .scale(
        duration: 2000.ms,
        begin: const Offset(1, 1),
        end: const Offset(1.05, 1.05),
      );
}

Widget buildGreeting(
  BuildContext context,
  AppLocalizations l10n,
  ThemeData theme, {
  Color? foregroundColor,
  Color? mutedColor,
}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcome,
          style: theme.textTheme.bodySmall?.copyWith(
            color: mutedColor ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.xs),
        Text(
          l10n.hello(
            getIt<HiveService>().auth.retrieveProfile()?.member?.lastName ?? '',
          ),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: foregroundColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}

Widget buildAnimatedCard({
  required BuildContext context,
  required Widget child,
  required int delay,
  bool animate = true,
}) {
  if (!animate || MediaQuery.disableAnimationsOf(context)) {
    return child;
  }

  return Animate(
    effects: [
      FadeEffect(
        duration: 360.ms,
        delay: Duration(milliseconds: delay),
      ),
      SlideEffect(
        duration: 420.ms,
        delay: Duration(milliseconds: delay),
        begin: const Offset(0, 0.08),
        curve: Curves.easeOut,
      ),
    ],
    child: child,
  );
}

class LandingActionSection {
  const LandingActionSection({
    required this.title,
    required this.actions,
  });

  final String title;
  final List<LandingActionItem> actions;
}

List<Widget> buildSectionSlivers({
  required BuildContext context,
  required List<LandingActionSection> sections,
  required int columns,
  bool animateEntrance = true,
  TextStyle? sectionHeaderStyle,
  double assetHeight = 46,
}) {
  final theme = Theme.of(context);
  final slivers = <Widget>[];
  var runningIndex = 0;

  // Tile height budget: padding + asset + gap + two scaled title lines.
  // Fixed aspect ratios overflow as soon as text scale grows; an explicit
  // extent keeps every tile intact at any accessibility size.
  final titleStyle =
      theme.textTheme.titleSmall ?? const TextStyle(fontSize: 14, height: 1.4);
  final titleLineExtent = MediaQuery.textScalerOf(context).scale(
    (titleStyle.fontSize ?? 14) * (titleStyle.height ?? 1.4),
  );
  final tileExtent =
      PRFSpacingTokens.md * 2 +
      assetHeight +
      PRFSpacingTokens.xs +
      titleLineExtent * 2 +
      PRFSpacingTokens.sm;

  for (final section in sections) {
    final sectionStart = runningIndex;
    runningIndex += section.actions.length;

    slivers
      ..add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              PRFSpacingTokens.lg,
              PRFSpacingTokens.lg,
              PRFSpacingTokens.lg,
              PRFSpacingTokens.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style:
                      sectionHeaderStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: PRFSpacingTokens.xs),
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
      ..add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.lg,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: PRFSpacingTokens.sm,
              mainAxisSpacing: PRFSpacingTokens.sm,
              mainAxisExtent: tileExtent,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final action = section.actions[index];
                return buildAnimatedCard(
                  context: context,
                  delay: action.animationDelay + ((sectionStart + index) * 40),
                  animate: animateEntrance,
                  child: LandingActionTile(
                    title: action.title,
                    assetPath: action.assetPath,
                    onTap: action.onTap,
                    assetHeight: assetHeight,
                    isNeutralCard: action.isNeutralCard,
                    isAccent: action.isAccent,
                  ),
                );
              },
              childCount: section.actions.length,
            ),
          ),
        ),
      );
  }

  return slivers;
}
