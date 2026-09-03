import 'package:app/features/home/landing/_shared.dart';
import 'package:app/features/home/landing/models/landing_action_item.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/helpers/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class LandingPageHandset extends StatefulWidget {
  const LandingPageHandset({required this.actions, super.key});

  final List<LandingActionItem> actions;

  @override
  State<LandingPageHandset> createState() => _LandingPageHandsetState();
}

class _LandingPageHandsetState extends State<LandingPageHandset> {
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

    // The entrance cascade plays exactly once per screen instance.
    final animateEntrance = !_state.entrancePlayed;
    _state.entrancePlayed = true;

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
                      buildProfilePicture(context, theme, 56),
                      const SizedBox(width: PRFSpacingTokens.lg),
                      buildGreeting(context, l10n, theme),
                    ],
                  ),
                ),
              ),

              // Section grids
              ...buildSectionSlivers(
                context: context,
                sections: sections,
                columns: 2,
                animateEntrance: animateEntrance,
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
}
