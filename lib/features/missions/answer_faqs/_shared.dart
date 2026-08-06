import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/shared/media_upload/widgets/audio_player_widget.dart';
import 'package:app/shared/media_upload/widgets/offline_audio_recorder_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AnswerFAQsFormState {
  AnswerFAQsFormState();

  late final VoidCallback _rebuild;

  final searchController = TextEditingController();
  String query = '';

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  void initListeners() {
    searchController.addListener(() {
      final next = searchController.text.trim().toLowerCase();
      if (next == query) return;
      query = next;
      _rebuild();
    });
  }

  void load(BuildContext context) {
    context.read<MissionQuestionResourceCubit>().loadAll();
  }

  void dispose() {
    searchController.dispose();
  }
}

Future<void> openRecorder(
  BuildContext context,
  PRFMissionQuestion question,
  AnswerFAQsFormState form,
) async {
  await PRFBottomSheet.show<void>(
    context,
    title: context.l10n.recordAnswer,
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: OfflineAudioRecorderSheet(
        model: PRFMediaModel.missionQuestions,
        modelUlid: question.ulid,
      ),
    ),
  );
  // ignore: use_build_context_synchronously
  await context.read<MissionQuestionResourceCubit>().loadAll();
}

Future<void> openAnswers(
  BuildContext context,
  PRFMissionQuestion question,
) async {
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
    PRFSnackbar.info(context, context.l10n.noAnswersYet);
    return;
  }

  await PRFBottomSheet.show<void>(
    context,
    title: context.l10n.answers,
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
