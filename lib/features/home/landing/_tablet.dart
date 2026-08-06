import 'package:app/features/home/landing/_shared.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';
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
    final width = MediaQuery.sizeOf(context).width;

    // Grid column count: adjust based on available tablet width
    final columns = width >= 1024 ? 4 : 3;

    final visibleActions = widget.actions
        .where((action) => action.isVisible)
        .toList();

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Column - main action grids (flex: 3)
                Expanded(
                  flex: 3,
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: PRFSpacingTokens.lg),
                      ),
                      ...buildSectionSlivers(
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

                // Vertical Divider
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.12),
                ),

                // Right Column - Premium Dashboard Info Panel (flex: 2)
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header card
                        Row(
                          children: [
                            buildProfilePicture(context, theme, 72),
                            const SizedBox(width: PRFSpacingTokens.lg),
                            buildGreeting(context, l10n, theme),
                          ],
                        ),
                        const SizedBox(height: PRFSpacingTokens.xxl),

                        // Interactive / informational panel
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.md,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Icon(
                                  Icons.explore_outlined,
                                  size: 72,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: PRFSpacingTokens.lg),
                                Text(
                                  l10n.dashboardTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Text(
                                  l10n.dashboardSubtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
