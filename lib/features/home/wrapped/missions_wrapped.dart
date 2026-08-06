import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/_handset.dart';
import 'package:app/features/home/wrapped/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class MissionsWrappedPage extends StatefulWidget {
  const MissionsWrappedPage({super.key});

  @override
  State<MissionsWrappedPage> createState() => _MissionsWrappedPageState();
}

class _MissionsWrappedPageState extends State<MissionsWrappedPage> {
  @override
  void initState() {
    super.initState();

    context.read<MemberEngagementResourceCubit>().loadEngagement(
      year: DateTime.now().year,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (_, _) => const MissionsWrappedHandset(),
      handset: (_) => const MissionsWrappedHandset(),
      tablet: (_) => const MissionsWrappedTablet(),
    );
  }
}
