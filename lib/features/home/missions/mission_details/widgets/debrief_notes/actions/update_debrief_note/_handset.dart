import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/update_debrief_note_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class UpdateDebriefNoteViewHandset extends StatefulWidget {
  const UpdateDebriefNoteViewHandset({
    required this.debriefNote,
    required this.missionUlid,
    super.key,
  });

  final PRFDebriefNote debriefNote;
  final String missionUlid;

  @override
  State<UpdateDebriefNoteViewHandset> createState() =>
      _UpdateDebriefNoteViewHandsetState();
}

class _UpdateDebriefNoteViewHandsetState
    extends State<UpdateDebriefNoteViewHandset> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid => _noteController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    // Pre-populate with existing note data
    _noteController.text = widget.debriefNote.note;

    _noteController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Note',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Note
            _buildFormSection(
              title: l10n.note,
              isRequired: true,
              child: PRFTextAreaInput(
                hintText: l10n.addDebriefNoteDesc,
                controller: _noteController,
                enabled: !_isLoading,
                maxLines: 6,
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            BlocConsumer<UpdateDebriefNoteCubit, UpdateDebriefNoteState>(
              listener: (context, state) {
                state.mapOrNull(
                  loading: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  loaded: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    PRFSnackbar.success(context, l10n.noteRecorded);
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    PRFSnackbar.error(context, error.message);
                  },
                );
              },
              builder: (context, state) {
                return PRFPrimaryButton(
                  onPressed: _submitForm,
                  title: 'Update',
                  disabled: !_isFormValid,
                  isLoading: _isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = context.l10n;

    if (_noteController.text.trim().isEmpty) {
      PRFSnackbar.warning(context, l10n.enterDebriefNote);
      Gaimon.warning();
      return;
    }

    await context.read<UpdateDebriefNoteCubit>().updateDebriefNote(
      debriefNoteUlid: widget.debriefNote.ulid,
      missionUlid: widget.missionUlid,
      note: _noteController.text.trim(),
    );
  }
}
