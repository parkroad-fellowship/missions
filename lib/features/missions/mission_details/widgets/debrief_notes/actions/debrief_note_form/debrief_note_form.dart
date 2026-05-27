import 'package:app/features/missions/mission_details/widgets/debrief_notes/actions/debrief_note_form/_handset.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class DebriefNoteFormView extends StatelessWidget {
  const DebriefNoteFormView({
    required this.missionUlid,
    this.debriefNote,
    super.key,
  });

  final String missionUlid;
  final PRFDebriefNote? debriefNote;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => DebriefNoteFormViewHandset(
        missionUlid: missionUlid,
        debriefNote: debriefNote,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => DebriefNoteFormViewHandset(
          missionUlid: missionUlid,
          debriefNote: debriefNote,
        ),
      ),
    );
  }
}
