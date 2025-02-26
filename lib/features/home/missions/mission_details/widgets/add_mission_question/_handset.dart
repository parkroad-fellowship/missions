import 'package:app/features/home/missions/cubit/add_mission_question_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AddMissionQuestionViewHandset extends StatefulWidget {
  const AddMissionQuestionViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddMissionQuestionViewHandset> createState() =>
      _AddMissionQuestionViewHandsetState();
}

class _AddMissionQuestionViewHandsetState
    extends State<AddMissionQuestionViewHandset> {
  final _questionController = TextEditingController();
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
                label: l10n.addQuestion,
                isRequired: true,
                
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.addQuestion,
              controller: _questionController,
              isTextBox: true,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            BlocConsumer<AddMissionQuestionCubit, AddMissionQuestionState>(
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.questionRecorded)),
                    );
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => PrimaryButton(
                        title: _isLoading ? l10n.recording : l10n.record,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                        onPressed: () async {
                          if (_questionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterQuestion)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          await context
                              .read<AddMissionQuestionCubit>()
                              .addMissionQuestion(
                                missionUlid: widget.missionUlid,
                                question: _questionController.text,
                              );
                        },
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
