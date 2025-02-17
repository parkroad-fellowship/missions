import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DebriefNotesViewHandset extends StatefulWidget {
  const DebriefNotesViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<DebriefNotesViewHandset> createState() =>
      _DebriefNotesViewHandsetState();
}

class _DebriefNotesViewHandsetState extends State<DebriefNotesViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetDebriefNotesCubit>().getDebriefNotes(
      missionUlid: missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetDebriefNotesCubit, GetDebriefNotesState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          loaded: (debriefNotes) {
            if (debriefNotes.isEmpty) {
              return Center(
                child: Text(
                  l10n.noNotes,
                  style: PRFText.theme().headlineSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFApp.theme().kPrimaryColorV2,
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: debriefNotes.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder:
                  (context, index) =>
                      DebriefNoteCard(debriefNote: debriefNotes[index]),
            );
          },
        );
      },
    );
  }
}

class DebriefNoteCard extends StatelessWidget {
  const DebriefNoteCard({required this.debriefNote, super.key});

  final PRFDebriefNote debriefNote;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debriefNote.note, style: PRFText.theme().bodySmall),
                SizedBox(height: 8.h),
                Text(
                  Misc.formatDateTime(debriefNote.createdAt),
                  style: PRFText.theme().bodySmall,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
