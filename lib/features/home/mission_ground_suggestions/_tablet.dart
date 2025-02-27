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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MissionGroundSuggestionsPageTablet extends StatefulWidget {
  const MissionGroundSuggestionsPageTablet({super.key});

  @override
  State<MissionGroundSuggestionsPageTablet> createState() =>
      _MissionGroundSuggestionsPageTabletState();
}

class _MissionGroundSuggestionsPageTabletState
    extends State<MissionGroundSuggestionsPageTablet> {
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
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 36,)),
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.w,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: const EdgeInsets.only(left: 8),
                        onPressed:
                            () => context.router.popUntilRouteWithPath(
                              PRFSuperAppRouter.landingRoute,
                            ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.suggestAMission,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: const Visibility(
                        child: Icon(Icons.abc, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<
                  GetMissionGroundSuggestionsCubit,
                  GetMissionGroundSuggestionsState
                >(
                  builder:
                      (context, state) => state.maybeWhen(
                        orElse:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => const SizedBox.shrink(),
                        loaded: (_) => const SizedBox.shrink(),
                      ),
                ),
              ),
              BlocBuilder<
                GetMissionGroundSuggestionsCubit,
                GetMissionGroundSuggestionsState
              >(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse:
                        () => const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    error:
                        (message) => SliverFillRemaining(
                          child: Center(child: Text(message)),
                        ),
                    loaded: (missionGroundSuggestions) {
                      if (missionGroundSuggestions.isEmpty) {
                        return SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh:
                                () =>
                                    context
                                        .read<
                                          GetMissionGroundSuggestionsCubit
                                        >()
                                        .getMissionGroundSuggestions(),
                            child: Center(
                              child: PRFPrimaryButton(
                                title: l10n.suggestAMission,
                                disabled: false,
                                onPressed: _addMissionGroundSuggestion,
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverList.separated(
                        itemCount: missionGroundSuggestions.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 8.h),
                        itemBuilder:
                            (context, index) => GestureDetector(
                              onLongPress:
                                  () async => _updateMissionGroundSuggestion(
                                    missionGroundSuggestions[index],
                                  ),
                              child: MissionGroundSuggestionCard(
                                missionGroundSuggestion:
                                    missionGroundSuggestions[index],
                              ),
                            ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Animate(
        effects: const [
          ShimmerEffect(
            duration: Duration(seconds: 2),
            delay: Duration(milliseconds: 500),
          ),
        ],
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: _addMissionGroundSuggestion,
          child: const Icon(Icons.add, color: Colors.white),
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
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: UpdateMissionGroundSuggestionView(
                missionGroundSuggestion: missionGroundSuggestion,
              ),
            ),
          ),
        ];
      },
    ).then((_) {
      // ignore: use_build_context_synchronously
      context
          .read<GetMissionGroundSuggestionsCubit>()
          .getMissionGroundSuggestions();
    });
  }

  void _addMissionGroundSuggestion() => WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return [
        WoltModalSheetPage(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: const AddMissionGroundSuggestionView(),
          ),
        ),
      ];
    },
  ).then((_) {
    // ignore: use_build_context_synchronously
    context
        .read<GetMissionGroundSuggestionsCubit>()
        .getMissionGroundSuggestions();
  });
}
