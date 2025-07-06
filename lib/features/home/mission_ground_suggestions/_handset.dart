import 'package:app/features/home/mission_ground_suggestions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/get_mission_ground_suggestions_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/update_mission_ground_suggestion/update_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/widgets/mission_ground_suggestion_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';

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
        .read<GetMissionGroundSuggestionsCubit>()
        .getMissionGroundSuggestions();
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
            // Enhanced Navigation Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              elevation: 0,
              toolbarHeight: 80,
              flexibleSpace: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                        onPressed: () => context.router.popUntilRouteWithPath(
                          PRFSuperAppRouter.landingRoute,
                        ),
                      ),
                    ),
                    // Title
                    Expanded(
                      child: Text(
                        l10n.suggestAMission,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Spacer to balance the back button
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver:
                  BlocBuilder<
                    GetMissionGroundSuggestionsCubit,
                    GetMissionGroundSuggestionsState
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        loading: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        error: (message) => SliverFillRemaining(
                          child: PRFEmptyView(
                            label: 'Error',
                            description: message,
                          ),
                        ),
                        empty: () => SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh: () => context
                                .read<GetMissionGroundSuggestionsCubit>()
                                .getMissionGroundSuggestions(),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PRFEmptyView(
                                      label: l10n.suggestAMission,
                                      description:
                                          l10n.suggestAMissionDescription,
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      child: PRFPrimaryButton(
                                        title: l10n.suggestAMission,
                                        disabled: false,
                                        onPressed: _addMissionGroundSuggestion,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        loaded: (missionGroundSuggestions) {
                          return SliverPadding(
                            padding: const EdgeInsets.only(
                              bottom: 100,
                            ), // Space for FAB
                            sliver: SliverList.separated(
                              itemCount: missionGroundSuggestions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final suggestion =
                                    missionGroundSuggestions[index];
                                return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
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
                                      end: const Offset(1.0, 1.0),
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
          borderRadius: BorderRadius.circular(16),
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
                  delay: Duration(milliseconds: 500),
                ),
                const ScaleEffect(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1.0, 1.0),
                  duration: Duration(milliseconds: 400),
                ),
              ],
            ),
      ),
    );
  }

  Future<void> _updateMissionGroundSuggestion(
    PRFMissionGroundSuggestion missionGroundSuggestion,
  ) async {
    if (!Misc.userCan('edit mission ground suggestion')) {
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
            .read<GetMissionGroundSuggestionsCubit>()
            .getMissionGroundSuggestions();
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
            .read<GetMissionGroundSuggestionsCubit>()
            .getMissionGroundSuggestions();
      }
    });
  }
}
