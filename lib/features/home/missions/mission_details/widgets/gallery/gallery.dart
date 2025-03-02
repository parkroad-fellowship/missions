import 'package:app/features/home/missions/mission_details/widgets/gallery/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => GalleryViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => GalleryViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
