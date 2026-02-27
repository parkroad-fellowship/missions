import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/actions/update_debrief_note/_handset.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateDebriefNoteView extends StatelessWidget {
  const UpdateDebriefNoteView({
    required this.debriefNote,
    required this.missionUlid,
    super.key,
  });

  final PRFDebriefNote debriefNote;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => UpdateDebriefNoteViewHandset(
        debriefNote: debriefNote,
        missionUlid: missionUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => UpdateDebriefNoteViewHandset(
          debriefNote: debriefNote,
          missionUlid: missionUlid,
        ),
      ),
    );
  }
}
