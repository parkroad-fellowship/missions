import 'package:app/features/home/mission_ground_suggestions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/get_mission_ground_suggestions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/primary_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MissionGroundSuggestionsPageHandset extends StatefulWidget {
  const MissionGroundSuggestionsPageHandset({
    super.key,
  });

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.landingRoute,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.suggestAMission,
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 80.sp),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetMissionGroundSuggestionsCubit,
                    GetMissionGroundSuggestionsState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () =>
                        const Center(child: LinearProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    loaded: (_) => const SizedBox.shrink(),
                  ),
                ),
              ),
              BlocBuilder<GetMissionGroundSuggestionsCubit,
                  GetMissionGroundSuggestionsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (message) =>
                        SliverToBoxAdapter(child: Center(child: Text(message))),
                    loaded: (missionGroundSuggestions) {
                      if (missionGroundSuggestions.isEmpty) {
                        return SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh: () => context
                                .read<GetMissionGroundSuggestionsCubit>()
                                .getMissionGroundSuggestions(),
                            child: Center(
                              child: PrimaryButton(
                                title: l10n.suggestAMission,
                                disabled: false,
                                onPressed: () => WoltModalSheet.show<void>(
                                  context: context,
                                  pageListBuilder: (modalSheetContext) {
                                    return [
                                      WoltModalSheetPage(
                                        child: SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.8,
                                          child:
                                              AddMissionGroundSuggestionView(),
                                        ),
                                      ),
                                    ];
                                  },
                                ).then((_) {
                                  if (context.mounted) {
                                    context
                                        .read<
                                            GetMissionGroundSuggestionsCubit>()
                                        .getMissionGroundSuggestions();
                                  }
                                }),
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverList.separated(
                        itemCount: missionGroundSuggestions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) =>
                            MissionGroundSuggestionCard(
                          missionGroundSuggestion:
                              missionGroundSuggestions[index],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalSheetContext) {
            return [
              WoltModalSheetPage(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  child: AddMissionGroundSuggestionView(),
                ),
              ),
            ];
          },
        ).then((_) {
          if (context.mounted) {
            context
                .read<GetMissionGroundSuggestionsCubit>()
                .getMissionGroundSuggestions();
          }
        }),
      ),
    );
  }
}

class MissionGroundSuggestionCard extends StatelessWidget {
  const MissionGroundSuggestionCard({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 60.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.appTheme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionGroundSuggestion.name,
                  style: CustomTextTheme.customTextTheme().bodySmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  missionGroundSuggestion.contactPerson,
                  style: CustomTextTheme.customTextTheme().bodySmall,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
