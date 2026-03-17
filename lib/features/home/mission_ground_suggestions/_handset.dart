import 'package:app/features/home/mission_ground_suggestions/actions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/actions/update_mission_ground_suggestion/update_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/widgets/mission_ground_suggestion_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
    context
        .read<GroundSuggestionResourceCubit>()
        .loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.suggestAMission,
              onBack: () => context.router.back(),
              backgroundColor: theme.colorScheme.surface,
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              sliver:
                  BlocBuilder<
                    GroundSuggestionResourceCubit,
                    ResourceState<PRFMissionGroundSuggestion>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        listLoading: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        error: (message, _) => SliverFillRemaining(
                          child: SliverFillRemaining(
                            child: RefreshIndicator(
                              onRefresh: () => context
                                  .read<GroundSuggestionResourceCubit>()
                                  .loadAll(),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: PRFEmptyView(
                                  label: l10n.noSuggestedMissionGrounds,
                                  description: message,
                                ),
                              ),
                            ),
                          ),
                        ),
                        listLoaded: (missionGroundSuggestions, _, __) {
                          if (missionGroundSuggestions.isEmpty) {
                            return SliverFillRemaining(
                              child: RefreshIndicator(
                                onRefresh: () => context
                                    .read<GroundSuggestionResourceCubit>()
                                    .loadAll(),
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: PRFEmptyView(
                                    label: l10n.suggestAMission,
                                    description:
                                        l10n.suggestMissionDescription,
                                    actionLabel: l10n.suggestAMission,
                                    onActionPressed:
                                        _addMissionGroundSuggestion,
                                  ),
                                ),
                              ),
                            );
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.only(
                              bottom: 100,
                            ), // Space for FAB
                            sliver: SliverList.separated(
                              itemCount: missionGroundSuggestions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: PRFSpacingTokens.lg),
                              itemBuilder: (context, index) {
                                final suggestion =
                                    missionGroundSuggestions[index];
                                return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: PRFSpacingTokens.xs,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.lg,
                                        ),
                                        child: InkWell(
                                          onLongPress: () async =>
                                              _updateMissionGroundSuggestion(
                                                suggestion,
                                              ),
                                          borderRadius: BorderRadius.circular(
                                            20,
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
                                        milliseconds: index * 100,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: const Duration(
                                        milliseconds: 600,
                                      ),
                                    )
                                    .slideY(
                                      begin: 0.3,
                                      end: 0,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeOutCubic,
                                    )
                                    .scale(
                                      begin: const Offset(0.9, 0.9),
                                      end: const Offset(1, 1),
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
            ).animate(
              effects: [
                const ShimmerEffect(
                  duration: Duration(seconds: 2),
                  delay: PRFMotionTokens.enterShort,
                ),
                const ScaleEffect(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1, 1),
                  duration: PRFMotionTokens.slow,
                ),
              ],
            ),
      ),
    );
  }

  Future<void> _updateMissionGroundSuggestion(
    PRFMissionGroundSuggestion missionGroundSuggestion,
  ) async {
    if (!PermissionHelper.userCan('edit mission ground suggestion')) {
      return;
    }

    await WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: UpdateMissionGroundSuggestionView(
                missionGroundSuggestion: missionGroundSuggestion,
              ),
            ),
          ),
        ];
      },
    ).then((_) {
      if (mounted) {
        context
            .read<GroundSuggestionResourceCubit>()
            .loadAll();
      }
    });
  }

  void _addMissionGroundSuggestion() {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: const AddMissionGroundSuggestionView(),
            ),
          ),
        ];
      },
    ).then((_) {
      if (mounted) {
        context
            .read<GroundSuggestionResourceCubit>()
            .loadAll();
      }
    });
  }
}
