import 'package:app/enums/prf_mission_status.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/notification_bell.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsPageHandset extends StatefulWidget {
  const MissionsPageHandset({super.key});

  @override
  State<MissionsPageHandset> createState() => _MissionsPageHandsetState();
}

class _MissionsPageHandsetState extends State<MissionsPageHandset> {
  @override
  void initState() {
    context.read<GetMissionsCubit>().getMissions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.missions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: const [
          NotificationBell(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<GetMissionsCubit, GetMissionsState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(child: Text(message)),
              loaded: (missions) {
                if (missions.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<GetMissionsCubit>().getMissions(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.directions_walk,
                        ),
                        Center(
                          child: Text(
                            l10n.noMissions,
                            style: CustomTextTheme.customTextTheme()
                                .headlineMedium!
                                .copyWith(
                                  color: AppTheme.appTheme().kDullGreyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: CustomTextTheme.customTextTheme()
                                    .displayLarge!
                                    .copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<GetMissionsCubit>().getMissions(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.appTheme().kDullGreyColor,
                          size: 24,
                        ),
                        title: Text(
                          mission.school!.name.toUpperCase(),
                          style: CustomTextTheme.customTextTheme()
                              .headlineSmall!
                              .copyWith(
                                color:
                                    AppTheme.appTheme().kAccent2BackgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        children: [
                          ListTile(
                            dense: true,
                            minLeadingWidth: 10.5,
                            contentPadding: const EdgeInsets.only(left: 20),
                            visualDensity: VisualDensity.compact,
                            onTap: () => context.router.push(
                              MissionsDetailsRoute(mission: mission),
                            ),
                            title: Text(
                              l10n.missionType(mission.missionType!.name),
                              style: CustomTextTheme.customTextTheme()
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.missionStart(
                                    Misc.formatDate(mission.startDate),
                                    Misc.formatTime(mission.startTime),
                                  ),
                                  style: CustomTextTheme.customTextTheme()
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                ),
                                Text(
                                  PRFMissionStatusExtension.fromIndex(
                                    mission.status,
                                  ).name,
                                  style: CustomTextTheme.customTextTheme()
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: PRFMissionStatusExtension
                                            .switchColor(
                                          PRFMissionStatusExtension.fromIndex(
                                            mission.status,
                                          ),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
