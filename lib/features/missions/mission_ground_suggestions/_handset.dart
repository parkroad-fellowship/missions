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

class MissionGroundSuggestionsPageHandset extends StatefulWidget {
  const MissionGroundSuggestionsPageHandset({super.key});

  @override
  State<MissionGroundSuggestionsPageHandset> createState() =>
      _MissionGroundSuggestionsPageHandsetState();
}

class _MissionGroundSuggestionsPageHandsetState
    extends State<MissionGroundSuggestionsPageHandset> {
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

    return BlocBuilder<
      GroundSuggestionResourceCubit,
      ResourceState<PRFMissionGroundSuggestion>
    >(
      builder: (context, state) {
        // Same source as the list: pull-to-refresh keeps cards visible
        // instead of flashing a full-screen spinner.
        final missionGroundSuggestions =
            context.read<GroundSuggestionResourceCubit>().currentItems;
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
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              buildSuggestionsHeader(
                context,
                theme,
                l10n,
                missionGroundSuggestions.length,
                pendingCount,
                completedCount,
                () => context.router.back(),
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
                        padding: const EdgeInsets.fromLTRB(
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          110,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) =>
                              missionGroundSuggestions.isEmpty
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

                            return SliverList.builder(
                              itemCount: suggestions.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: PRFSpacingTokens.md,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.recentSuggestions,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.78),
                                                ),
                                          ),
                                        ),
                                        Text(
                                          '${suggestions.length}',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final suggestionIndex = index - 1;
                                final suggestion = suggestions[suggestionIndex];
                                return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            suggestionIndex ==
                                                suggestions.length - 1
                                            ? 0
                                            : PRFSpacingTokens.lg,
                                      ),
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
                                          splashColor: theme.colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          highlightColor: theme
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.05),
                                          child: MissionGroundSuggestionCard(
                                            missionGroundSuggestion: suggestion,
                                          ),
                                        ),
                                      ),
                                    )
                                    .animate(
                                      delay: Duration(
                                        milliseconds: 70 * suggestionIndex,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideY(
                                      begin: 0.22,
                                      end: 0,
                                      duration: PRFMotionTokens.enterMedium,
                                      curve: Curves.easeOutCubic,
                                    );
                              },
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
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child:
                FloatingActionButton.extended(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      onPressed: () => triggerAddSuggestion(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        l10n.suggestAMission,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: PRFMotionTokens.enterMedium)
                    .slideY(begin: 0.2, end: 0),
          ),
        );
      },
    );
  }
}
