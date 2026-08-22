import 'package:app/features/home/landing/_shared.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class LandingPageTablet extends StatefulWidget {
  const LandingPageTablet({required this.actions, super.key});

  final List<LandingActionItem> actions;

  @override
  State<LandingPageTablet> createState() => _LandingPageTabletState();
}

class _LandingPageTabletState extends State<LandingPageTablet> {
  final _state = LandingState();

  @override
  void initState() {
    super.initState();
    _state
      ..attach(() => setState(() {}))
      ..prefetch(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state.initializeNotifications();
    });
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final visibleActions = widget.actions
        .where((action) => action.isVisible)
        .toList();

    // The entrance cascade plays exactly once per screen instance; later
    // rebuilds (prefetch setState) and scrolled-in cards skip it.
    final animateEntrance = !_state.entrancePlayed;
    _state.entrancePlayed = true;

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
          (entry) => LandingActionSection(
            title: entry.key,
            actions: entry.value,
          ),
        )
        .toList();

    return PRFTabletSplitScaffold(
      content: LayoutBuilder(
        builder: (context, constraints) {
          // Fewer, larger tiles: eight actions read better as
          // generous cards than as a dense 4-up grid here.

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: PRFSpacingTokens.lg),
              ),
              if (sections.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyActions(theme, l10n),
                )
              else
                ...buildSectionSlivers(
                  context: context,
                  sections: sections,
                  columns: 2,
                  assetHeight: 72,
                  animateEntrance: animateEntrance,
                  sectionHeaderStyle: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: PRFSpacingTokens.xl),
              ),
            ],
          );
        },
      ),

      // Right Column - Living Root dashboard panel (flex: 2)
      sidePanel: _buildBrandPanel(l10n, theme),
    );
  }

  Widget _buildEmptyActions(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
          Text(
            l10n.emptyActionsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          Text(
            l10n.emptyActionsBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPanel(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PRFColors.navyBlue,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          child: Stack(
            children: [
              const Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(painter: PRFRootMotifPainter()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildProfilePicture(
                          context,
                          theme,
                          72,
                          ringColor: PRFColors.limeGreen,
                          semanticsLabel: l10n.myAccount,
                        ),
                        const SizedBox(width: PRFSpacingTokens.lg),
                        buildGreeting(
                          context,
                          l10n,
                          theme,
                          foregroundColor: Colors.white,
                          mutedColor: PRFColors.navy100,
                        ),
                      ],
                    ),
                    const SizedBox(height: PRFSpacingTokens.xxl),
                    Expanded(child: _buildLiveContent(l10n, theme)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveContent(AppLocalizations l10n, ThemeData theme) {
    return BlocBuilder<
      AnnouncementResourceCubit,
      ResourceState<PRFAnnouncement>
    >(
      builder: (context, announcementState) {
        final announcements = [
          ...context.read<AnnouncementResourceCubit>().currentItems,
        ]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        final topAnnouncements = announcements.take(3).toList();
        final prompts = context.read<GetPrayerPromptsCubit>().prompts;

        final isLoading = announcementState.maybeWhen(
          initial: () => true,
          listLoading: (_) => true,
          orElse: () => false,
        );

        if (topAnnouncements.isEmpty && prompts.isEmpty) {
          return isLoading
              ? _buildPanelSkeleton(theme)
              : _buildPanelFallback(l10n, theme);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (topAnnouncements.isNotEmpty) ...[
                _panelSectionLabel(l10n.announcements, theme),
                const SizedBox(height: PRFSpacingTokens.md),
                for (final announcement in topAnnouncements)
                  _AnnouncementRow(
                    title: announcement.title,
                    dateLabel: l10n.publishedAt(
                      DateFormat.yMMMd().format(announcement.publishedAt),
                    ),
                    onTap: () => context.router.pushPath(
                      PRFSuperAppRouter.announcementsRoute,
                    ),
                  ),
                const SizedBox(height: PRFSpacingTokens.xxl),
              ],
              if (prompts.isNotEmpty) ...[
                _panelSectionLabel(l10n.prayerPrompt, theme),
                const SizedBox(height: PRFSpacingTokens.md),
                _PrayerPromptCard(
                  description: prompts.first.description,
                  onTap: () => context.router.pushPath(
                    PRFSuperAppRouter.prayerRequestRoute,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanelSkeleton(ThemeData theme) {
    Widget bar(double width, double height, {double radius = 8}) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 3; i++) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(180, 14),
                const SizedBox(height: PRFSpacingTokens.sm),
                bar(110, 11, radius: 6),
              ],
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.md),
        ],
      ],
    );
  }

  Widget _panelSectionLabel(String label, ThemeData theme) {
    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: PRFColors.navy100,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildPanelFallback(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_outlined,
              size: 72,
              color: Colors.white,
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Text(
              l10n.dashboardTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            Text(
              l10n.dashboardSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: PRFColors.navy100,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementRow extends StatelessWidget {
  const _AnnouncementRow({
    required this.title,
    required this.dateLabel,
    required this.onTap,
  });

  final String title;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.lg,
            vertical: PRFSpacingTokens.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                dateLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrayerPromptCard extends StatelessWidget {
  const _PrayerPromptCard({
    required this.description,
    required this.onTap,
  });

  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: PRFColors.limeGreen,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.volunteer_activism_rounded,
                    size: 20,
                    color: PRFColors.navyBlue,
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Text(
                    AppLocalizations.of(context).prayerPrompt,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: PRFColors.navyBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: PRFColors.navyBlue,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
