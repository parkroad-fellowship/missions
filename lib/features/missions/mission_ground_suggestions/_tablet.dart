import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/missions/mission_ground_suggestions/_shared.dart';
import 'package:app/features/missions/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/features/missions/mission_ground_suggestions/widgets/mission_ground_suggestion_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

    return BlocBuilder<
      GroundSuggestionResourceCubit,
      ResourceState<PRFMissionGroundSuggestion>
    >(
      builder: (context, state) {
        final missionGroundSuggestions = state.maybeWhen(
          listLoaded: (suggestions, _, _) => suggestions,
          orElse: List<PRFMissionGroundSuggestion>.empty,
        );
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

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Suggestions list/grid (flex: 3)
                    Expanded(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: () async => _form.load(context),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () => context.router.back(),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.suggestAMission,
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.refresh_rounded),
                                      onPressed: () => _form.load(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                listLoading: (_) => const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: PRFCircularProgressIndicator(),
                                  ),
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
                                          description:
                                              l10n.suggestMissionDescription,
                                          actionLabel: l10n.suggestAMission,
                                          onActionPressed: () =>
                                              triggerAddSuggestion(context),
                                        ),
                                      ),
                                    );
                                  }

                                  return SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: columns,
                                          crossAxisSpacing: PRFSpacingTokens.lg,
                                          mainAxisSpacing: PRFSpacingTokens.lg,
                                          childAspectRatio: 1.4,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final suggestion = suggestions[index];
                                        return Material(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    PRFRadiusTokens.xl,
                                                  ),
                                              child: InkWell(
                                                onLongPress: () =>
                                                    triggerUpdateSuggestion(
                                                      context,
                                                      suggestion,
                                                    ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      PRFRadiusTokens.xl,
                                                    ),
                                                child:
                                                    MissionGroundSuggestionCard(
                                                      missionGroundSuggestion:
                                                          suggestion,
                                                    ),
                                              ),
                                            )
                                            .animate(
                                              delay: Duration(
                                                milliseconds: 70 * index,
                                              ),
                                            )
                                            .fadeIn(
                                              duration:
                                                  PRFMotionTokens.enterShort,
                                            )
                                            .slideY(
                                              begin: 0.22,
                                              end: 0,
                                              duration:
                                                  PRFMotionTokens.enterMedium,
                                              curve: Curves.easeOutCubic,
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

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Suggestions Stats & Action Sidebar (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ground Suggestions',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Stats Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.md,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.suggestMissionSubTitle,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SuggestionStatPill(
                                          label: l10n.total,
                                          value:
                                              missionGroundSuggestions.length,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.sm,
                                      ),
                                      Expanded(
                                        child: SuggestionStatPill(
                                          label: 'Pending',
                                          value: pendingCount,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.sm,
                                      ),
                                      Expanded(
                                        child: SuggestionStatPill(
                                          label: 'Completed',
                                          value: completedCount,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Guidance cards
                            Center(
                              child: Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Suggest Mission Grounds',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Suggest new schools or centers that need spiritual interventions. The fellowship review board evaluates all entries to establish new missions.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),

                            // Suggest action button
                            PRFButton(
                              onPressed: () => triggerAddSuggestion(context),
                              title: l10n.suggestAMission,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
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
      },
    );
  }
}
