import 'package:app/features/home/mission_ground_suggestions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/get_mission_ground_suggestions_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/update_mission_ground_suggestion/update_mission_ground_suggestion.dart';
import 'package:app/l10n/l10n.dart';
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
                            color: PRFApp.theme().kPrimaryColorV2,
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
                        style: PRFText.theme()
                            .displayLarge
                            ?.copyWith(fontSize: 80.sp),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Visibility(
                          child: Icon(
                            Icons.abc,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                    orElse: () => const SliverFillRemaining(
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
                                onPressed: _addMissionGroundSuggestion,
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverList.separated(
                        itemCount: missionGroundSuggestions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () {
                            if (!Misc.userCan(
                              'edit mission ground suggestion',
                            )) {
                              return;
                            }
                            WoltModalSheet.show<void>(
                              context: context,
                              pageListBuilder: (modalSheetContext) {
                                return [
                                  WoltModalSheetPage(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                                    
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.8,
                                      child: UpdateMissionGroundSuggestionView(
                                        missionGroundSuggestion:
                                            missionGroundSuggestions[index],
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
                          },
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
          backgroundColor: PRFApp.theme().kPrimaryColorV2,
          onPressed: _addMissionGroundSuggestion,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
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
      effects: const [
        SaturateEffect(),
      ],
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
              color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: missionGroundSuggestion.name,
                          style: PRFText.theme().displayLarge?.copyWith(
                                color: PRFApp.theme().kPrimaryColorV2,
                                fontWeight: FontWeight.w600,
                              ),
                          children: [
                            TextSpan(
                              text: ', ${missionGroundSuggestion.status.name}',
                              style: PRFText.theme().displaySmall?.copyWith(
                                    color: PRFApp.theme().kPrimaryColorV2,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        missionGroundSuggestion.contactPerson,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 4.h,
                  ),
                  child: Visibility(
                    visible: Misc.userCan('viewAny mission ground suggestion'),
                    child: Animate(
                      effects: const [
                        ShakeEffect(
                          duration: Duration(seconds: 2),
                          delay: Duration(milliseconds: 500),
                        ),
                      ],
                      child: IconButton(
                        icon: const Icon(Icons.call),
                        color: PRFApp.theme().kPrimaryColorV2,
                        onPressed: () async {
                          final uri = Uri(
                            scheme: 'tel',
                            path: missionGroundSuggestion.contactNumber,
                          );
                          await Misc.openUrl(uri);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
