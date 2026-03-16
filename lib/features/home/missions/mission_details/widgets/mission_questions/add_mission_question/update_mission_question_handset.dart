import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/update_mission_question_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:prf_design/prf_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class UpdateMissionQuestionViewHandset extends StatefulWidget {
  const UpdateMissionQuestionViewHandset({
    required this.missionQuestion,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionQuestion missionQuestion;
  final String missionUlid;

  @override
  State<UpdateMissionQuestionViewHandset> createState() =>
      _UpdateMissionQuestionViewHandsetState();
}

class _UpdateMissionQuestionViewHandsetState
    extends State<UpdateMissionQuestionViewHandset> {
  final _questionController = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid => _questionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    // Pre-populate with existing question data
    _questionController.text = widget.missionQuestion.question;

    _questionController.addListener(() => setState(() {}));
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
              'Update Question',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Question
            _buildFormSection(
              title: l10n.addQuestion,
              isRequired: true,
              child: PRFTextAreaInput(
                hintText: l10n.addQuestionDesc,
                controller: _questionController,
                enabled: !_isLoading,
                maxLines: 6,
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            BlocConsumer<
              UpdateMissionQuestionCubit,
              UpdateMissionQuestionState
            >(
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
                    PRFSnackbar.success(context, l10n.questionRecorded);
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

    if (_questionController.text.trim().isEmpty) {
      PRFSnackbar.warning(context, l10n.enterQuestion);
      Gaimon.warning();
      return;
    }

    await context.read<UpdateMissionQuestionCubit>().updateMissionQuestion(
      missionQuestionUlid: widget.missionQuestion.ulid,
      missionUlid: widget.missionUlid,
      question: _questionController.text.trim(),
    );
  }
}
