import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class DebriefNoteFormViewHandset extends StatefulWidget {
  const DebriefNoteFormViewHandset({
    required this.missionUlid,
    this.debriefNote,
    super.key,
  });

  final String missionUlid;
  final PRFDebriefNote? debriefNote;

  @override
  State<DebriefNoteFormViewHandset> createState() =>
      _DebriefNoteFormViewHandsetState();
}

class _DebriefNoteFormViewHandsetState
    extends State<DebriefNoteFormViewHandset> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  bool get _isEditing => widget.debriefNote != null;

  // Structured validation
  bool _showValidation = false;
  String? _noteError;

  bool get _isFormValid => _noteController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _noteController.text = widget.debriefNote!.note;
    }
    _noteController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _noteError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_noteController.text.trim().isEmpty) {
      _noteError = 'Note is required';
    }

    setState(() => _showValidation = true);
    return _noteError == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Update Note' : l10n.addDebriefNote,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Note
            PRFFormSection(
              icon: Icons.edit_note,
              title: l10n.note,
              isRequired: true,
              child: PRFTextAreaInput(
                hintText: l10n.addDebriefNoteDesc,
                controller: _noteController,
                enabled: !_isLoading,
                maxLines: 6,
                errorText: _showValidation ? _noteError : null,
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Submit Button
            BlocConsumer<
              DebriefNoteResourceCubit,
              ResourceState<PRFDebriefNote>
            >(
              listener: (context, state) {
                state.mapOrNull(
                  mutating: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  mutated: (_) {
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
                  title: _isEditing ? 'Update' : l10n.record,
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

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      Gaimon.warning();
      PRFSnackbar.error(
        context,
        'Please fix the highlighted fields and try again.',
      );
      return;
    }

    if (_isEditing) {
      await context.read<DebriefNoteResourceCubit>().updateDebriefNote(
        ulid: widget.debriefNote!.ulid,
        missionUlid: widget.missionUlid,
        note: _noteController.text.trim(),
      );
    } else {
      await context.read<DebriefNoteResourceCubit>().addDebriefNote(
        missionUlid: widget.missionUlid,
        note: _noteController.text.trim(),
      );
    }
  }
}
