import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebriefNotesViewHandset extends StatefulWidget {
  const DebriefNotesViewHandset({
    required this.missionUlid,
    super.key,
  });

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
                  l10n.noSubscribers,
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.appTheme().kPrimaryColorV2,
                          ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: debriefNotes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final debriefNote = debriefNotes[index];
                return ListTile(
                  title: Text(debriefNote.note),
                  subtitle: Text(Misc.formatDateTime(debriefNote.createdAt)),
                  onTap: () {},
                );
              },
            );
          },
        );
      },
    );
  }
}
