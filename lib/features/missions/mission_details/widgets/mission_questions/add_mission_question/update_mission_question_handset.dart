import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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

  // Structured validation
  bool _showValidation = false;
  String? _questionError;

  bool get _isFormValid => _questionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.missionQuestion.question;
    _questionController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _questionError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_questionController.text.trim().isEmpty) {
      _questionError = 'Question is required';
    }

    setState(() => _showValidation = true);
    return _questionError == null;
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
              'Update Question',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Question
            PRFFormSection(
              icon: Icons.help_outline,
              title: l10n.addQuestion,
              isRequired: true,
              child: PRFTextField(
                type: PRFTextFieldType.textArea,
                hintText: l10n.addQuestionDesc,
                controller: _questionController,
                enabled: !_isLoading,
                maxLines: 6,
                errorText: _showValidation ? _questionError : null,
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Submit Button
            BlocConsumer<
              MissionQuestionResourceCubit,
              ResourceState<PRFMissionQuestion>
            >(
              listener: (context, state) {
                state.mapOrNull(
                  mutating: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  listLoaded: (_) {
                    if (!_isLoading) return;
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
                return PRFButton(
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

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      Gaimon.warning();
      PRFSnackbar.error(
        context,
        'Please fix the highlighted fields and try again.',
      );
      return;
    }

    await context.read<MissionQuestionResourceCubit>().updateMissionQuestion(
      ulid: widget.missionQuestion.ulid,
      missionUlid: widget.missionUlid,
      question: _questionController.text.trim(),
    );
  }
}
