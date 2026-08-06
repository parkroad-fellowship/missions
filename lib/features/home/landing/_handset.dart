import 'package:app/di/di_container.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/features/home/landing/widgets/landing_action_tile.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helpers/navigation_helper.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:prf_design/prf_design.dart';

class LandingPageHandset extends StatelessWidget {
  const LandingPageHandset({required this.actions, super.key});

  final List<LandingActionItem> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 430 ? 3 : 2;
    final visibleActions = actions.where((action) => action.isVisible).toList();

    // Group actions by deskGroup
    final deskGroups = <String, List<LandingActionItem>>{};
    for (final action in visibleActions) {
      final group = action.deskGroup;
      if (group == null || group.isEmpty) continue;
      deskGroups.putIfAbsent(group, () => <LandingActionItem>[]).add(action);
    }

    final sections = deskGroups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map(
          (entry) => _LandingActionSection(
            title: entry.key,
            actions: entry.value,
          ),
        )
        .toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => NavigationHelper.exitApp(
        context: context,
        didPop: didPop,
        result: result,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                  child: Row(
                    children: [
                      _buildProfilePicture(context, theme, 56),
                      const SizedBox(width: PRFSpacingTokens.lg),
                      _buildGreeting(context, l10n, theme),
                      // _buildNotificationButton(context, theme),
                    ],
                  ),
                ),
              ),

              // Section grids
              ..._buildSectionSlivers(
                context: context,
                sections: sections,
                columns: columns,
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: PRFSpacingTokens.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(
    BuildContext context,
    ThemeData theme,
    double size,
  ) {
    return GestureDetector(
          onTap: () => context.router.pushPath(
            PRFSuperAppRouter.accountRoute,
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
                          errorBuilder: (context, error, stackTrace) =>
                              CircleAvatar(
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
                              getIt<HiveService>().retrieveMember()?.fullName ??
                                  '',
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
        )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          duration: 2000.ms,
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
        )
        .then(delay: 1000.ms);
  }

  Widget _buildGreeting(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcome,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            l10n.hello(
              getIt<HiveService>().auth.retrieveProfile()?.member?.lastName ??
                  '',
            ),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationButton(BuildContext context, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.router.pushPath(
          PRFSuperAppRouter.announcementsRoute,
        ),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required Widget child,
    required int delay,
  }) {
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

  List<Widget> _buildSectionSlivers({
    required BuildContext context,
    required List<_LandingActionSection> sections,
    required int columns,
  }) {
    final theme = Theme.of(context);
    final slivers = <Widget>[];
    var runningIndex = 0;

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
                    style: theme.textTheme.titleMedium?.copyWith(
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
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final action = section.actions[index];
                  return _buildAnimatedCard(
                    delay:
                        action.animationDelay + ((sectionStart + index) * 40),
                    child: LandingActionTile(
                      title: action.title,
                      assetPath: action.assetPath,
                      onTap: action.onTap,
                      assetHeight: 46,
                      isNeutralCard: action.isNeutralCard,
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
}

class _LandingActionSection {
  const _LandingActionSection({
    required this.title,
    required this.actions,
  });

  final String title;
  final List<LandingActionItem> actions;
}
