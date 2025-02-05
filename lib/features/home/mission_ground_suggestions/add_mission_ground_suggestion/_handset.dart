import 'package:app/features/home/missions/cubit/add_debrief_note_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMissionGroundSuggestionViewHandset extends StatefulWidget {
  const AddMissionGroundSuggestionViewHandset({
    super.key,
  });

  @override
  State<AddMissionGroundSuggestionViewHandset> createState() =>
      _AddMissionGroundSuggestionViewHandsetState();
}

class _AddMissionGroundSuggestionViewHandsetState
    extends State<AddMissionGroundSuggestionViewHandset> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.note,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.note,
              controller: _noteController,
              isTextBox: true,
            ),
            const SizedBox(height: 16),
            BlocConsumer<AddDebriefNoteCubit, AddDebriefNoteState>(
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
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.noteRecorded),
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => PrimaryButton(
                    title: _isLoading ? l10n.recording : l10n.record,
                    disabled: _isLoading,
                    isLoading: _isLoading ? true : null,
                    onPressed: () {},
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
