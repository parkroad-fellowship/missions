import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/home/mission_ground_suggestions/actions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/actions/update_mission_ground_suggestion/update_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/widgets/mission_ground_suggestion_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<GroundSuggestionResourceCubit>().loadAll();
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
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.88),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    PRFBrandedNavBar(
                      title: l10n.suggestAMission,
                      onBack: () => context.router.back(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.xs,
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.lg,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.suggestMissionSubTitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Wrap(
                              spacing: PRFSpacingTokens.xs,
                              runSpacing: PRFSpacingTokens.xs,
                              children: [
                                _StatPill(
                                  label: l10n.total,
                                  value: missionGroundSuggestions.length,
                                ),
                                _StatPill(
                                  label: PRFMissionGroundSuggestionStatus
                                      .pending
                                      .name,
                                  value: pendingCount,
                                ),
                                _StatPill(
                                  label: l10n.completed,
                                  value: completedCount,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<GroundSuggestionResourceCubit>().loadAll(),
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
                          listLoading: () => const SliverFillRemaining(
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
                                    description: l10n.suggestMissionDescription,
                                    actionLabel: l10n.suggestAMission,
                                    onActionPressed:
                                        _addMissionGroundSuggestion,
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
                                        color: PRFColors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.xl,
                                        ),
                                        child: InkWell(
                                          onLongPress: () async {
                                            await _updateMissionGroundSuggestion(
                                              suggestion,
                                            );
                                          },
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
                      onPressed: _addMissionGroundSuggestion,
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

  Future<void> _updateMissionGroundSuggestion(
    PRFMissionGroundSuggestion missionGroundSuggestion,
  ) async {
    if (!PermissionHelper.userCan('edit mission ground suggestion')) {
      return;
    }

    await PRFBottomSheet.show<void>(
      context,
      title: context.l10n.editMissionSuggestion,
      child: UpdateMissionGroundSuggestionView(
        missionGroundSuggestion: missionGroundSuggestion,
      ),
    ).then((_) {
      if (mounted) {
        context.read<GroundSuggestionResourceCubit>().loadAll();
      }
    });
  }

  void _addMissionGroundSuggestion() {
    PRFBottomSheet.show<void>(
      context,
      title: context.l10n.suggestAMission,
      child: const AddMissionGroundSuggestionView(),
    ).then((_) {
      if (mounted) {
        context.read<GroundSuggestionResourceCubit>().loadAll();
      }
    });
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
