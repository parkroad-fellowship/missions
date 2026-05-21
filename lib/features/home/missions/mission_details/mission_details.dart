import 'package:app/di/di_container.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/cubit/mission_details_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/_handset.dart';
import 'package:app/services/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MissionsDetailsPage extends StatelessWidget {
  const MissionsDetailsPage({
    @PathParam('missionUlid') required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MissionDetailsResourceCubit>(
          create: (_) => MissionDetailsResourceCubit(
            missionService: getIt<MissionService>(),
            dbService: getIt<IsarService>().missions,
          )..loadMission(missionUlid: missionUlid),
        ),
        BlocProvider<MissionSubscriptionResourceCubit>(
          create: (_) => MissionSubscriptionResourceCubit(
            missionSubscriptionService: getIt<MissionSubscriptionService>(),
            dbService: getIt<IsarService>().missionSubscriptions,
          ),
        ),
      ],
      child: MissionsDetailsPageHandset(missionUlid: missionUlid),
    );
  }
}
