import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/missions/mission_ground_suggestions/_shared.dart';
import 'package:app/features/missions/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/features/missions/mission_ground_suggestions/widgets/mission_ground_suggestion_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/shared/widgets/build_animated_timeline_entry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionGroundSuggestionsPageTablet extends StatefulWidget {
  const MissionGroundSuggestionsPageTablet({super.key});

  @override
  State<MissionGroundSuggestionsPageTablet> createState() =>
      _MissionGroundSuggestionsPageTabletState();
}

class _MissionGroundSuggestionsPageTabletState
    extends State<MissionGroundSuggestionsPageTablet> {
  final _form = GroundSuggestionsFormState();

  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      GroundSuggestionResourceCubit,
      ResourceState<PRFMissionGroundSuggestion>
    >(
      builder: (context, state) {
        final missionGroundSuggestions = context
            .read<GroundSuggestionResourceCubit>()
            .currentItems;
        final pendingCount = missionGroundSuggestions
            .where(
              (suggestion) =>
                  suggestion.status == PRFMissionGroundSuggestionStatus.pending,
            )
            .length;
        final completedCount = missionGroundSuggestions
            .where(
              (suggestion) =>
                  suggestion.status ==
                  PRFMissionGroundSuggestionStatus.completed,
            )
            .length;

        // The entrance cascade plays exactly once per screen instance;
        // later rebuilds (refresh setState) and scrolled-in cards skip it.
        final animateEntrance = !_entrancePlayed;
        _entrancePlayed = true;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.suggestAMission,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => _form.load(context),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _form.load(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) => missionGroundSuggestions.isEmpty
                              ? const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: PRFCircularProgressIndicator(),
                                  ),
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
                                ),
                          error: (message, _) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: PRFEmptyView(
                                label: l10n.noSuggestedMissionGrounds,
                                description: message,
                              ),
                            ),
                          ),
                          listLoaded: (suggestions, _, _) {
                            if (suggestions.isEmpty) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.suggestAMission,
                                    description: l10n.suggestMissionDescription,
                                    actionLabel: l10n.suggestAMission,
                                    onActionPressed: () =>
                                        triggerAddSuggestion(context),
                                  ),
                                ),
                              );
                            }

                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 340,
                                    crossAxisSpacing: PRFSpacingTokens.lg,
                                    mainAxisSpacing: PRFSpacingTokens.lg,
                                    childAspectRatio: 1.4,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final suggestion = suggestions[index];
                                  return buildAnimatedTimelineEntry(
                                    context: context,
                                    index: index,
                                    animate: animateEntrance,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.xl,
                                      ),
                                      child: InkWell(
                                        onLongPress: () =>
                                            triggerUpdateSuggestion(
                                              context,
                                              suggestion,
                                            ),
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.xl,
                                        ),
                                        child: MissionGroundSuggestionCard(
                                          missionGroundSuggestion: suggestion,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: suggestions.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sidePanel: PRFBrandPanel(
            children: [
              PRFPanelSectionLabel(l10n.groundSuggestions),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.suggestMissionSubTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Wrap(
                spacing: PRFSpacingTokens.sm,
                runSpacing: PRFSpacingTokens.sm,
                children: [
                  SuggestionStatPill(
                    label: l10n.total,
                    value: missionGroundSuggestions.length,
                  ),
                  SuggestionStatPill(
                    label: l10n.pendingStatus,
                    value: pendingCount,
                  ),
                  SuggestionStatPill(
                    label: l10n.completed,
                    value: completedCount,
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xxl),
              Center(
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: PRFOpacities.half),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.suggestGroundsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.suggestGroundsPanelBody,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              PRFButton(
                variant: PRFButtonVariant.secondary,
                onPressed: () => triggerAddSuggestion(context),
                title: l10n.suggestAMission,
              ),
            ],
          ),
        );
      },
    );
  }
}
