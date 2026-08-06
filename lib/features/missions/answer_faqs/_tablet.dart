import 'package:app/features/missions/answer_faqs/_shared.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/utils/crud/resource_state.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Column - Search and Questions list (flex: 3)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                          vertical: PRFSpacingTokens.lg,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: PRFSpacingTokens.xs),
                            Text(
                              l10n.answerFaqs,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                        ),
                        child: Semantics(
                          label: context.l10n.searchQuestions,
                          child: PRFTextField(
                            hintText: context.l10n.searchQuestions,
                            controller: _form.searchController,
                          ),
                        ),
                      ),
                      const SizedBox(height: PRFSpacingTokens.lg),
                      Expanded(
                        child:
                            BlocBuilder<
                              MissionQuestionResourceCubit,
                              ResourceState<PRFMissionQuestion>
                            >(
                              builder: (context, state) {
                                final isLoading = state.maybeWhen(
                                  listLoading: (_) => true,
                                  orElse: () => false,
                                );

                                final questions = state.maybeWhen(
                                  listLoaded: (items, _, _) => items,
                                  listLoading: (items) => items,
                                  mutating: (items, _) => items,
                                  error: (_, items) => items,
                                  orElse: () => const <PRFMissionQuestion>[],
                                );

                                final filtered = _form.query.isEmpty
                                    ? questions
                                    : questions
                                          .where(
                                            (q) =>
                                                q.question
                                                    .toLowerCase()
                                                    .contains(
                                                      _form.query,
                                                    ) ||
                                                (q.mission?.theme
                                                        ?.toLowerCase()
                                                        .contains(
                                                          _form.query,
                                                        ) ??
                                                    false),
                                          )
                                          .toList();

                                if (isLoading && questions.isEmpty) {
                                  return Center(
                                    child: Semantics(
                                      label: context.l10n.loadingQuestions,
                                      child:
                                          const PRFCircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (filtered.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        PRFSpacingTokens.xxl,
                                      ),
                                      child: Semantics(
                                        label: _form.query.isEmpty
                                            ? 'No questions yet'
                                            : 'No questions found',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.question_answer_outlined,
                                              size: 64,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.2),
                                            ),
                                            const SizedBox(
                                              height: PRFSpacingTokens.lg,
                                            ),
                                            Text(
                                              _form.query.isEmpty
                                                  ? 'No questions yet'
                                                  : 'No questions found',
                                              style:
                                                  theme.textTheme.headlineSmall,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: PRFSpacingTokens.sm,
                                            ),
                                            Text(
                                              _form.query.isEmpty
                                                  ? 'Questions from missions will appear here'
                                                  : 'Try a different search term',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return RefreshIndicator(
                                  onRefresh: () async => _form.load(context),
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PRFSpacingTokens.lg,
                                    ),
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, _) => const SizedBox(
                                      height: PRFSpacingTokens.md,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = filtered[index];
                                      return Container(
                                        padding: const EdgeInsets.all(
                                          PRFSpacingTokens.lg,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            PRFRadiusTokens.smd,
                                          ),
                                          border: Border.all(
                                            color: theme.colorScheme.outline
                                                .withValues(
                                                  alpha: 0.2,
                                                ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Semantics(
                                              header: true,
                                              child: Text(
                                                item.question,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            if (item.mission?.theme !=
                                                null) ...[
                                              const SizedBox(
                                                height: PRFSpacingTokens.xs,
                                              ),
                                              Semantics(
                                                label:
                                                    'Mission theme: ${item.mission!.theme!}',
                                                child: Text(
                                                  item.mission!.theme!,
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .outline,
                                                      ),
                                                ),
                                              ),
                                            ],
                                            const SizedBox(
                                              height: PRFSpacingTokens.sm,
                                            ),
                                            if (!item.hasAnswers)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: PRFSpacingTokens.sm,
                                                ),
                                                child: Semantics(
                                                  label:
                                                      context.l10n.noAnswersYet,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal:
                                                              PRFSpacingTokens
                                                                  .sm,
                                                          vertical:
                                                              PRFSpacingTokens
                                                                  .xs,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .statusColors
                                                          .warning
                                                          .background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            PRFRadiusTokens.xs,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'No answers yet',
                                                      style: theme
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: context
                                                                .statusColors
                                                                .warning
                                                                .onColor,
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
                                                    label:
                                                        'Record answer to: ${item.question}',
                                                    child: PRFButton(
                                                      onPressed: () =>
                                                          openRecorder(
                                                            context,
                                                            item,
                                                            _form,
                                                          ),
                                                      title: context
                                                          .l10n
                                                          .recordAnswer,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: PRFSpacingTokens.sm,
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Semantics(
                                                    button: true,
                                                    enabled: item.hasAnswers,
                                                    label:
                                                        '${item.answerCount} ${item.answerCount == 1 ? 'answer' : 'answers'}',
                                                    child: PRFButton(
                                                      variant: PRFButtonVariant
                                                          .secondary,
                                                      onPressed: () =>
                                                          openAnswers(
                                                            context,
                                                            item,
                                                          ),
                                                      title:
                                                          'Answers (${item.answerCount})',
                                                      disabled:
                                                          !item.hasAnswers,
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
                              },
                            ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.12),
                ),

                // Right Column - Supportive Info Sidebar (flex: 2)
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Missions FAQ Hub',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xl),

                        // Stats Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.md,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Record audio answers to student questions, which are transcribed into text automatically.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Guidance illustrations
                        Center(
                          child: Icon(
                            Icons.mic_none_outlined,
                            size: 64,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.md),
                        Text(
                          'Answer & Transcribe',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          'Review incoming student questions on the left. Tap "Record Answer" to capture your audio feedback, which is transcribed by AI to serve the fellowship.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
