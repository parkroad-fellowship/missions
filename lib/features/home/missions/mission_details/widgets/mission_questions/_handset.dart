import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/get_mission_questions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_mission_question.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
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

  @override
  void initState() {
    context.read<GetMissionQuestionsCubit>().getMissionQuestions(
      missionUlid: missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleStreamWrapper(
      stream: getIt<IsarService>().missionQuestions.parentStream,
      nullWidget: PRFEmptyView(
        label: l10n.noQuestions,
        description: l10n.questionsWillAppearHere,
        icon: Icons.help_outline_rounded,
      ),
      widget: (context, missionQuestions) => RefreshIndicator(
        onRefresh: () =>
            context.read<GetMissionQuestionsCubit>().getMissionQuestions(
              missionUlid: missionUlid,
            ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.lg),
            itemCount: missionQuestions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) =>
                BeautifulMissionQuestionCard(
                      missionQuestion: missionQuestions[index],
                      index: index,
                    )
                    .animate(delay: (index * 100).ms)
                    .fadeIn()
                    .slideX(begin: -0.3, end: 0),
          ),
        ),
      ),
    );
  }
}

class BeautifulMissionQuestionCard extends StatelessWidget with TimezoneMixin {
  const BeautifulMissionQuestionCard({
    required this.missionQuestion,
    required this.index,
    super.key,
  });

  final PRFLocalMissionQuestion missionQuestion;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg, vertical: PRFSpacingTokens.sm),
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
          // Header with question icon and type
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
            ],
          ),

          // Question content
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
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.sm, vertical: PRFSpacingTokens.xs),
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
