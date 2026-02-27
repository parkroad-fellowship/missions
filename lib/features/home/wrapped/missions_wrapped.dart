import 'package:app/features/home/shared/cubit/get_member_engagement_cubit.dart';
import 'package:app/features/home/wrapped/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    context.read<GetMemberEngagementCubit>().getMemberEngagement(
      year: DateTime.now().year,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const MissionsWrappedHandset(),
    );
  }
}
