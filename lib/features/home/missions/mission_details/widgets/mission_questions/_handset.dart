import 'package:app/features/home/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
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
    extends State<MissionQuestionsViewHandset> {
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
      data: {
        'mission_ulid': missionUlid,
        'question': question.trim(),
      },
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
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.sm,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.md,
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: PRFPrimaryButton(
            onPressed: _showAddQuestionSheet,
            title: l10n.addQuestion,
            disabled: false,
          ),
        ),
        Expanded(
          child:
              BlocBuilder<
                MissionQuestionResourceCubit,
                ResourceState<PRFMissionQuestion>
              >(
                builder: (context, state) {
                  return state.maybeWhen(
                    listLoading: () => const Center(
                      child: PRFCircularProgressIndicator(),
                    ),
                    listLoaded: (missionQuestions, _, _) {
                      if (missionQuestions.isEmpty) {
                        return PRFEmptyView(
                          label: l10n.noQuestions,
                          description: l10n.questionsWillAppearHere,
                          icon: Icons.help_outline_rounded,
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () => context
                            .read<MissionQuestionResourceCubit>()
                            .loadAll(
                              filters: {'mission_ulid': missionUlid},
                            ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              vertical: PRFSpacingTokens.lg,
                            ),
                            itemCount: missionQuestions.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0),
                            itemBuilder: (context, index) =>
                                BeautifulMissionQuestionCard(
                                      missionQuestion: missionQuestions[index],
                                      index: index,
                                      onEdit: () => _updateQuestion(
                                        missionQuestions[index],
                                      ),
                                      onDelete: () => _deleteQuestion(
                                        missionQuestions[index],
                                      ),
                                    )
                                    .animate(delay: (index * 100).ms)
                                    .fadeIn()
                                    .slideX(begin: -0.3, end: 0),
                          ),
                        ),
                      );
                    },
                    error: (message, _) => PRFEmptyView(
                      label: l10n.noQuestions,
                      description: message,
                      icon: Icons.help_outline_rounded,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
        ),
      ],
    );
  }
}

class BeautifulMissionQuestionCard extends StatelessWidget with TimezoneMixin {
  const BeautifulMissionQuestionCard({
    required this.missionQuestion,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PRFMissionQuestion missionQuestion;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      margin: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.missionQuestion,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.xs),
                    _buildTimestampChip(theme),
                  ],
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              SizedBox(
                width: 72,
                child: PRFSecondaryButton(
                  onPressed: onEdit,
                  title: context.l10n.edit,
                  disabled: false,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              SizedBox(
                width: 76,
                child: PRFDestroyButton(
                  onPressed: onDelete,
                  title: context.l10n.delete,
                  disabled: false,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.help_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Text(
                    missionQuestion.question,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(effects: const [SaturateEffect()]);
  }

  Widget _buildTimestampChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            DateFormatter.formatDateTime(missionQuestion.createdAt, timezone),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
