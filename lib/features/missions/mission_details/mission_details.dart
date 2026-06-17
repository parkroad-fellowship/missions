import 'package:app/di/di_container.dart';
import 'package:app/features/missions/mission_details/_handset.dart';
import 'package:app/features/missions/mission_details/cubit/mission_details_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
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
            hiveService: getIt<HiveService>(),
          )..loadMission(missionUlid: missionUlid),
        ),
        BlocProvider<MissionSubscriptionResourceCubit>(
          create: (_) => MissionSubscriptionResourceCubit(
            missionSubscriptionService: getIt<MissionSubscriptionService>(),
            hiveService: getIt<HiveService>(),
          ),
        ),
      ],
      child: MissionsDetailsPageHandset(missionUlid: missionUlid),
    );
  }
}
