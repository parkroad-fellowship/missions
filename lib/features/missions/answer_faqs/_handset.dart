import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/shared/media_upload/widgets/audio_player_widget.dart';
import 'package:app/shared/media_upload/widgets/offline_audio_recorder_sheet.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AnswerFAQsPageHandset extends StatefulWidget {
  const AnswerFAQsPageHandset({super.key});

  @override
  State<AnswerFAQsPageHandset> createState() => _AnswerFAQsPageHandsetState();
}

class _AnswerFAQsPageHandsetState extends State<AnswerFAQsPageHandset> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<MissionQuestionResourceCubit>().loadAll();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final next = _searchController.text.trim().toLowerCase();
    if (next == _query) return;
    setState(() => _query = next);
  }

  Future<void> _openRecorder(PRFMissionQuestion question) async {
    await PRFBottomSheet.show<void>(
      context,
      title: 'Record answer',
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: OfflineAudioRecorderSheet(
          model: PRFMediaModel.missionQuestions,
          modelUlid: question.ulid,
        ),
      ),
    );
    if (!mounted) return;
    await context.read<MissionQuestionResourceCubit>().loadAll();
  }

  Future<void> _openAnswers(PRFMissionQuestion question) async {
    final mediaAnswers = question.questionMediaAnswers;
    final transcriptEntries = question.transcripts;

    final mediaByUuid = <String, PRFMedia>{};
    for (final media in mediaAnswers) {
      mediaByUuid[media.uuid] = media;
    }
    for (final t in transcriptEntries) {
      final media = t.media;
      if (media == null) continue;
      mediaByUuid.putIfAbsent(media.uuid, () => media);
    }

    final orderedUuids = <String>[];
    for (final media in mediaAnswers) {
      orderedUuids.add(media.uuid);
    }
    for (final t in transcriptEntries) {
      final media = t.media;
      if (media == null) continue;
      if (!orderedUuids.contains(media.uuid)) {
        orderedUuids.add(media.uuid);
      }
    }

    if (orderedUuids.isEmpty) {
      PRFSnackbar.info(context, 'No answers yet');
      return;
    }

    await PRFBottomSheet.show<void>(
      context,
      title: 'Answers',
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${orderedUuids.length} answer${orderedUuids.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Expanded(
              child: ListView.separated(
                itemCount: orderedUuids.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: PRFSpacingTokens.md),
                itemBuilder: (context, index) {
                  final uuid = orderedUuids[index];
                  final media = mediaByUuid[uuid];
                  if (media == null) {
                    return const SizedBox.shrink();
                  }
                  final transcript = transcriptEntries
                      .where((t) => t.media?.uuid == uuid)
                      .map((t) => t.content)
                      .where((c) => c.trim().isNotEmpty)
                      .join('\n')
                      .trim();

                  final transcriptText = transcript.isEmpty ? null : transcript;
                  return Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: AudioPlayerWidget(
                      url: media.temporaryURL,
                      title: media.fileName,
                      transcript: transcriptText,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            PRFBrandedNavBar(title: l10n.answerFaqs),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PRFSpacingTokens.lg,
                PRFSpacingTokens.sm,
                PRFSpacingTokens.lg,
                PRFSpacingTokens.md,
              ),
              child: Semantics(
                label: 'Search questions',
                child: PRFTextInput(
                  hintText: 'Search questions',
                  controller: _searchController,
                ),
              ),
            ),
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

                      final filtered = _query.isEmpty
                          ? questions
                          : questions
                                .where(
                                  (q) =>
                                      q.question.toLowerCase().contains(
                                        _query,
                                      ) ||
                                      (q.mission?.theme?.toLowerCase().contains(
                                            _query,
                                          ) ??
                                          false),
                                )
                                .toList();

                      if (isLoading && questions.isEmpty) {
                        return Center(
                          child: Semantics(
                            label: 'Loading questions',
                            child: const PRFCircularProgressIndicator(),
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
                              label: _query.isEmpty
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
                                    _query.isEmpty
                                        ? 'No questions yet'
                                        : 'No questions found',
                                    style: theme.textTheme.headlineSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: PRFSpacingTokens.sm,
                                  ),
                                  Text(
                                    _query.isEmpty
                                        ? 'Questions from missions will appear here'
                                        : 'Try a different search term',
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSurface
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
                        onRefresh: () => context
                            .read<MissionQuestionResourceCubit>()
                            .loadAll(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            PRFSpacingTokens.lg,
                            0,
                            PRFSpacingTokens.lg,
                            PRFSpacingTokens.lg,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: PRFSpacingTokens.md),
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
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      item.question,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  if (item.mission?.theme != null) ...[
                                    const SizedBox(
                                      height: PRFSpacingTokens.xs,
                                    ),
                                    Semantics(
                                      label:
                                          'Mission theme: ${item.mission!.theme!}',
                                      child: Text(
                                        item.mission!.theme!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.outline,
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
                                        label: 'No answers yet',
                                        child: Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                horizontal:
                                                    PRFSpacingTokens.sm,
                                                vertical:
                                                    PRFSpacingTokens.xs,
                                              ),
                                          decoration: BoxDecoration(
                                            color: PRFColors.warningLight,
                                            borderRadius:
                                                BorderRadius.circular(
                                                  PRFRadiusTokens.xs,
                                                ),
                                          ),
                                          child: Text(
                                            'No answers yet',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color:
                                                      PRFColors.warningDark,
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
                                          child: PRFPrimaryButton(
                                            onPressed: () =>
                                                _openRecorder(item),
                                            title: 'Record answer',
                                            disabled: false,
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
                                          child: PRFSecondaryButton(
                                            onPressed: () =>
                                                _openAnswers(item),
                                            title:
                                                'Answers (${item.answerCount})',
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
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
