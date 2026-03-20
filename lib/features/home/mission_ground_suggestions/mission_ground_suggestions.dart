import 'package:app/features/home/mission_ground_suggestions/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MissionGroundSuggestionsPage extends StatelessWidget {
  const MissionGroundSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MissionGroundSuggestionsPageHandset();
  }
}
