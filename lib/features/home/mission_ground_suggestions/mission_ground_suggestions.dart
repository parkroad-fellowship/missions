import 'package:app/features/home/mission_ground_suggestions/_handset.dart';
import 'package:app/features/home/mission_ground_suggestions/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class MissionGroundSuggestionsPage extends StatelessWidget {
  const MissionGroundSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const MissionGroundSuggestionsPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const MissionGroundSuggestionsPageHandset(),
      ),
    );
  }
}
