import 'package:app/features/missions/answer_faqs/_shared.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AnswerFAQsPageTablet extends StatefulWidget {
  const AnswerFAQsPageTablet({super.key});

  @override
  State<AnswerFAQsPageTablet> createState() => _AnswerFAQsPageTabletState();
}

class _AnswerFAQsPageTabletState extends State<AnswerFAQsPageTablet> {
  final _form = AnswerFAQsFormState();

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..initListeners()
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      MissionQuestionResourceCubit,
      ResourceState<PRFMissionQuestion>
    >(
      builder: (context, state) {
        final questions = context
            .read<MissionQuestionResourceCubit>()
            .currentItems;
        final awaitingAnswers = questions.where((q) => !q.hasAnswers).length;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.answerFaqs,
                onBack: () => context.router.maybePop(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.lg,
                ),
                child: Semantics(
                  label: l10n.searchQuestions,
                  child: PRFTextField(
                    hintText: l10n.searchQuestions,
                    controller: _form.searchController,
                  ),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Expanded(child: _buildQuestionList(context, state)),
            ],
          ),
          sidePanel: _buildBrandPanel(
            l10n,
            questions: questions.length,
            awaitingAnswers: awaitingAnswers,
          ),
        );
      },
    );
  }

  Widget _buildQuestionList(
    BuildContext context,
    ResourceState<PRFMissionQuestion> state,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final isLoading = state.maybeWhen(
      listLoading: (_) => true,
      orElse: () => false,
    );

    final questions = context.read<MissionQuestionResourceCubit>().currentItems;

    final errorMessage = state.maybeWhen(
      error: (message, _) => message,
      itemError: (message, _, _) => message,
      orElse: () => null,
    );

    final filtered = _form.query.isEmpty
        ? questions
        : questions
              .where(
                (q) =>
                    q.question.toLowerCase().contains(_form.query) ||
                    (q.mission?.theme?.toLowerCase().contains(
                          _form.query,
                        ) ??
                        false),
              )
              .toList();

    if (isLoading && questions.isEmpty) {
      return Center(
        child: Semantics(
          label: l10n.loadingQuestions,
          child: const PRFCircularProgressIndicator(),
        ),
      );
    }

    if (filtered.isEmpty) {
      final isSearchMiss = _form.query.isNotEmpty && questions.isNotEmpty;
      return RefreshIndicator(
        onRefresh: () async => _form.load(context),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(PRFSpacingTokens.xxl),
                  child: Semantics(
                    label: _form.query.isEmpty
                        ? l10n.noQuestionsYet
                        : l10n.noQuestionsFound,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.question_answer_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.lg),
                        Text(
                          _form.query.isEmpty
                              ? l10n.noQuestionsYet
                              : l10n.noQuestionsFound,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          isSearchMiss
                              ? l10n.tryDifferentSearchTerm
                              : (errorMessage ??
                                    l10n.questionsFromMissionsBody),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _form.load(context),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          PRFSpacingTokens.lg,
          0,
          PRFSpacingTokens.lg,
          PRFSpacingTokens.xl,
        ),
        itemCount: filtered.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: PRFSpacingTokens.md),
        itemBuilder: (context, index) {
          final item = filtered[index];
          return Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    item.question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (item.mission?.theme != null) ...[
                  const SizedBox(height: PRFSpacingTokens.xs),
                  Semantics(
                    label: l10n.missionThemeLabel(item.mission!.theme!),
                    child: Text(
                      item.mission!.theme!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: PRFSpacingTokens.sm),
                if (!item.hasAnswers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
                    child: Semantics(
                      label: l10n.noAnswersYet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.sm,
                          vertical: PRFSpacingTokens.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.statusColors.warning.background,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.xs,
                          ),
                        ),
                        child: Text(
                          l10n.noAnswersYet,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: context.statusColors.warning.onColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: l10n.recordAnswerSemantic(item.question),
                        child: PRFButton(
                          onPressed: () =>
                              openRecorder(context, item, _form),
                          title: l10n.recordAnswer,
                        ),
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: Semantics(
                        button: true,
                        enabled: item.hasAnswers,
                        label: l10n.answersCount(item.answerCount),
                        child: PRFButton(
                          variant: PRFButtonVariant.secondary,
                          onPressed: () => openAnswers(context, item),
                          title: l10n.answersCount(item.answerCount),
                          disabled: !item.hasAnswers,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandPanel(
    AppLocalizations l10n, {
    required int questions,
    required int awaitingAnswers,
  }) {
    final theme = Theme.of(context);

    return PRFBrandPanel(
      children: [
        PRFPanelSectionLabel(l10n.missionsFaqHub),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
          l10n.faqHubIntro,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: PRFColors.navy100,
            height: 1.4,
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Row(
          children: [
            Expanded(
              child: _FaqStatChip(
                label: l10n.total,
                value: questions,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.sm),
            Expanded(
              child: _FaqStatChip(
                label: l10n.awaitingAnswers,
                value: awaitingAnswers,
                highlight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        Center(
          child: Icon(
            Icons.mic_none_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
          l10n.answerTranscribeTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        Text(
          l10n.faqHubPanelBody,
          style: theme.textTheme.bodySmall?.copyWith(
            color: PRFColors.navy100,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FaqStatChip extends StatelessWidget {
  const _FaqStatChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final int value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: highlight
          ? PRFColors.limeGreen
          : Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.md),
          child: Column(
            children: [
              Text(
                '$value',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: highlight
                      ? PRFColors.navyBlue
                      : Colors.white,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: highlight
                      ? PRFColors.navyBlue
                      : PRFColors.navy100,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
