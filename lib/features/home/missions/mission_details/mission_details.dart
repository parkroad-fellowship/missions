import 'package:app/features/home/missions/mission_details/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MissionsDetailsPage extends StatelessWidget {
  const MissionsDetailsPage({
    @PathParam('missionUlid') required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return MissionsDetailsPageHandset(missionUlid: missionUlid);
  }
}
