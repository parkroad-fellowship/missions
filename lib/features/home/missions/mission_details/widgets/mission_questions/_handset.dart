import 'package:app/features/home/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/record_sections.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionQuestionsViewHandset extends StatefulWidget {
  const MissionQuestionsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionQuestionsViewHandset> createState() =>
      _MissionQuestionsViewHandsetState();
}

class _MissionQuestionsViewHandsetState
    extends State<MissionQuestionsViewHandset>
    with TimezoneMixin {
  String get missionUlid => widget.missionUlid;

  Future<void> _showAddQuestionSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.addQuestion,
      child: AddMissionQuestionView(missionUlid: missionUlid),
    );
  }

  Future<String?> _showEditQuestionSheet(PRFMissionQuestion missionQuestion) {
    return PRFBottomSheet.show<String>(
      context,
      title: context.l10n.edit,
      child: _MissionQuestionFormBody(
        initialValue: missionQuestion.question,
        submitLabel: 'Update',
      ),
    );
  }

  Future<void> _updateQuestion(PRFMissionQuestion missionQuestion) async {
    final question = await _showEditQuestionSheet(missionQuestion);
    if (question == null || question.trim().isEmpty || !mounted) {
      return;
    }

    await context.read<MissionQuestionResourceCubit>().updateMissionQuestion(
      ulid: missionQuestion.ulid,
      missionUlid: missionUlid,
      question: question.trim(),
    );

    if (!mounted) return;

    final error = context.read<MissionQuestionResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );
    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }
    PRFSnackbar.success(context, 'Question updated');
  }

  Future<void> _deleteQuestion(PRFMissionQuestion missionQuestion) async {
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${context.l10n.delete} ${context.l10n.missionQuestion}',
      message: 'Are you sure you want to continue?',
      confirmLabel: context.l10n.delete,
      isDestructive: true,
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<MissionQuestionResourceCubit>().deleteMissionQuestion(
      missionQuestion.ulid,
    );
    if (!mounted) return;

    final error = context.read<MissionQuestionResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );
    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }
    PRFSnackbar.success(context, 'Question deleted');
  }

  @override
  void initState() {
    context.read<MissionQuestionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      MissionQuestionResourceCubit,
      ResourceState<PRFMissionQuestion>
    >(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          listLoading: (_) => true,
          orElse: () => false,
        );
        final error = state.mapOrNull(
          error: (s) => s.message,
        );
        final questions = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          mutating: (items, _) => items,
          mutated: (items, _, _) => items,
          orElse: () => <PRFMissionQuestion>[],
        );

        return MissionResourceTabView(
          sectionTitle: 'Mission Questions',
          addButtonLabel: l10n.addQuestion,
          addButtonIcon: Icons.add_comment_outlined,
          emptyLabel: l10n.noQuestions,
          emptyDescription: l10n.questionsWillAppearHere,
          isLoading: isLoading,
          error: error,
          isEmpty: questions.isEmpty,
          onRefresh: () => context.read<MissionQuestionResourceCubit>().loadAll(
            filters: {'mission_ulid': missionUlid},
          ),
          onAdd: _showAddQuestionSheet,
          items: [
            for (int index = 0; index < questions.length; index++)
              MissionResourceCard(
                    title: questions[index].question.isEmpty
                        ? 'Untitled question'
                        : questions[index].question,
                    subtitle:
                        'Captured ${DateFormatter.formatDateTime(questions[index].createdAt, timezone)}',
                    editTooltip: 'Edit question',
                    onEdit: () => _updateQuestion(questions[index]),
                    deleteTooltip: 'Delete question',
                    onDelete: () => _deleteQuestion(questions[index]),
                  )
                  .animate(delay: (index * 100).ms)
                  .fadeIn()
                  .slideX(begin: -0.3, end: 0),
          ],
        );
      },
    );
  }
}

class _MissionQuestionFormBody extends StatefulWidget {
  const _MissionQuestionFormBody({
    required this.initialValue,
    required this.submitLabel,
  });

  final String initialValue;
  final String submitLabel;

  @override
  State<_MissionQuestionFormBody> createState() =>
      _MissionQuestionFormBodyState();
}

class _MissionQuestionFormBodyState extends State<_MissionQuestionFormBody> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PRFTextAreaInput(
            hintText: context.l10n.addQuestionDesc,
            controller: _controller,
            maxLines: 6,
            errorText: _error,
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
          PRFPrimaryButton(
            onPressed: _submit,
            title: widget.submitLabel,
            disabled: false,
          ),
        ],
      ),
    );
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Question is required');
      return;
    }
    Navigator.of(context).pop(value);
  }
}
