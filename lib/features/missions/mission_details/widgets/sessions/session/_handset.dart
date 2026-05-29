import 'dart:io';

import 'package:app/di/di_container.dart';
import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/session_form.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/add_audio/add_audio.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/session/cubit/mission_session_details_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_transcript.dart';
import 'package:app/services/media/failed_recording_upload_service.dart';
import 'package:app/shared/media_upload/cubit/audio_recording_cubit.dart';
import 'package:app/shared/media_upload/cubit/recording_upload_cubit.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SessionPageHandset extends StatefulWidget {
  const SessionPageHandset({
    required this.missionSessionUlid,
    required this.missionUlid,
    required this.missionSessionId,
    super.key,
  });

  final int missionSessionId;
  final String missionSessionUlid;
  final String missionUlid;

  @override
  State<SessionPageHandset> createState() => _SessionPageHandsetState();
}

class _SessionPageHandsetState extends State<SessionPageHandset>
    with TimezoneMixin {
  int get missionSessionId => widget.missionSessionId;
  String get missionSessionUlid => widget.missionSessionUlid;
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showAddAudioSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.recordings,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: AddAudioView(
          missionUlid: missionUlid,
          missionSessionUlid: missionSessionUlid,
        ),
      ),
    );
  }

  Future<void> _uploadCompletedRecording({
    required String filePath,
    required Duration duration,
  }) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return;
    }

    await context.read<RecordingUploadCubit>().uploadRecording(
      PRFMediaDTO(
        model: PRFMediaModel.missionSessionLiveRecordings,
        modelUlid: missionSessionUlid,
        path: file.path,
        name: StringFormatter.getFileName(file.path),
      ),
    );

    if (!mounted) return;
    final durationText =
        '${duration.inMinutes}m '
        '${duration.inSeconds.remainder(60)}s';
    PRFSnackbar.success(
      context,
      'Recording saved ($durationText)',
    );
  }

  List<PRFTranscript> _sortedTranscripts(
    List<PRFTranscript> transcripts,
  ) => [...transcripts]
    ..sort((a, b) {
      final aDate = a.media?.createdAt;
      final bDate = b.media?.createdAt;

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Resolve session from cubit state
    final sessionState = context
        .watch<MissionSessionDetailsResourceCubit>()
        .state;
    final missionSession = sessionState.maybeWhen(
      itemLoaded: (item, _) => item,
      itemLoading: (_, item) => item,
      itemError: (_, _, item) => item,
      orElse: () => null,
    );
    final allTranscripts =
        missionSession?.transcripts ?? const <PRFTranscript>[];
    final readyTranscripts = allTranscripts.where(
      (item) => item.content.isNotEmpty,
    );
    final processingTranscripts = allTranscripts.where(
      (item) => item.content.isEmpty,
    );
    final visibleTranscripts = _sortedTranscripts(allTranscripts);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          ColoredBox(
            color: Theme.of(context).colorScheme.primary,
            child: PRFBrandedNavBar(
              onBack: () => context.router.back(),
              title: l10n.sessionDetails,
            ),
          ),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<AudioRecordingCubit, AudioRecordingState>(
                  listener: (context, state) {
                    state.mapOrNull(
                      completed: (value) {
                        _uploadCompletedRecording(
                          filePath: value.filePath,
                          duration: value.duration,
                        );
                      },
                    );
                  },
                ),
              ],
              child: RefreshIndicator(
                onRefresh: () => context
                    .read<MissionSessionDetailsResourceCubit>()
                    .loadSession(
                      missionSessionUlid: missionSessionUlid,
                      refresh: true,
                    ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                        ),
                        child: _RecordingStatusCard(
                          missionSessionUlid: missionSessionUlid,
                          onOpenRecorder: _showAddAudioSheet,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: PRFSpacingTokens.md),
                    ),
                    // Upload Status
                    SliverToBoxAdapter(
                      child: BlocConsumer<UploadMediaCubit, UploadMediaState>(
                        listener: (context, state) {
                          state.mapOrNull(
                            loaded: (_) {
                              context
                                  .read<MissionSessionDetailsResourceCubit>()
                                  .loadSession(
                                    missionSessionUlid: missionSessionUlid,
                                    refresh: true,
                                  );
                              PRFSnackbar.success(context, l10n.doneUploading);
                            },
                            error: (error) {
                              PRFSnackbar.error(context, error.message);
                            },
                          );
                        },
                        builder: (context, state) => state.maybeWhen(
                          loading: () => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.smd,
                              ),
                            ),
                            child: const Center(
                              child: PRFLinearProgressIndicator(),
                            ),
                          ),
                          error: (message) => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.smd,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                          orElse: () => const SizedBox(),
                        ),
                      ),
                    ),

                    // Session Loading State
                    SliverToBoxAdapter(
                      child:
                          BlocBuilder<
                            MissionSessionDetailsResourceCubit,
                            ResourceState<PRFMissionSession>
                          >(
                            builder: (context, state) => state.maybeWhen(
                              itemLoading: (_, _) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                ),
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                ),
                                child: const Center(
                                  child: PRFLinearProgressIndicator(),
                                ),
                              ),
                              listLoading: (_) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                ),
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                ),
                                child: const Center(
                                  child: PRFLinearProgressIndicator(),
                                ),
                              ),
                              error: (message, _) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                ),
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              itemError: (message, _, _) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                ),
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              orElse: () => const SizedBox(),
                            ),
                          ),
                    ),

                    // Session Data
                    if (missionSession != null) ...[
                      MissionSessionDataView(
                        missionSession: missionSession,
                        missionUlid: widget.missionUlid,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: PRFSpacingTokens.xl),
                      ),
                    ],

                    // Recordings Section
                    if (missionSession != null)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.lg,
                          ),
                          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.md,
                            ),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.sm,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primary.withValues(
                                        alpha: 0.12,
                                      ),
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.sm,
                                  ),
                                ),
                                child: Icon(
                                  Icons.audiotrack_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.recordings,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: PRFSpacingTokens.xs,
                                    ),
                                    Text(
                                      '${allTranscripts.length} total · '
                                      '${readyTranscripts.length} ready · '
                                      '${processingTranscripts.length} processing',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: PRFPrimaryButton(
                                  onPressed: () async {
                                    await _showAddAudioSheet();
                                  },
                                  title: 'Record',
                                  disabled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Pending / queued recordings for this session
                    if (missionSession != null)
                      StreamBuilder<List<PRFFailedRecordingUpload>>(
                        stream: getIt<FailedRecordingUploadService>()
                            .pendingUploadsStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SliverToBoxAdapter(child: SizedBox());
                          }

                          final sessionUploads = snapshot.data!
                              .where(
                                (upload) =>
                                    upload.modelUlid == missionSessionUlid,
                              )
                              .toList();

                          if (sessionUploads.isEmpty) {
                            return const SliverToBoxAdapter(child: SizedBox());
                          }

                          return SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: PRFSpacingTokens.lg,
                                vertical: PRFSpacingTokens.md,
                              ),
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.lg,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.smd,
                                ),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.sm,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Queued recordings for this session',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: PRFSecondaryButton(
                                          onPressed: () =>
                                              getIt<
                                                    FailedRecordingUploadService
                                                  >()
                                                  .retryAllUploadsForSession(
                                                    missionSessionUlid,
                                                  ),
                                          title: 'Retry all',
                                          disabled: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.sm),
                                  ...sessionUploads.map(
                                    (upload) => Container(
                                      margin: const EdgeInsets.only(
                                        bottom: PRFSpacingTokens.sm,
                                      ),
                                      padding: const EdgeInsets.all(
                                        PRFSpacingTokens.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.sm,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.audiotrack,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: PRFSpacingTokens.md,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  upload.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: PRFSpacingTokens.xs,
                                                ),
                                                Text(
                                                  'Queued • Will upload when '
                                                  'online',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: 0.6,
                                                            ),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            child: PRFSecondaryButton(
                                              onPressed: () =>
                                                  getIt<
                                                        FailedRecordingUploadService
                                                      >()
                                                      .retrySpecificUpload(
                                                        upload,
                                                      ),
                                              title: 'Retry',
                                              disabled: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    if (missionSession != null) ...[
                      const SliverToBoxAdapter(
                        child: SizedBox(height: PRFSpacingTokens.lg),
                      ),

                      // Recordings List
                      if (allTranscripts.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child:
                                Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.music_off_outlined,
                                          size: 64,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(
                                          height: PRFSpacingTokens.lg,
                                        ),
                                        Text(
                                          l10n.noRecordings,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .scale(begin: const Offset(0.8, 0.8)),
                          ),
                        )
                      else
                        SliverList.builder(
                          itemCount: visibleTranscripts.length,
                          itemBuilder: (context, index) =>
                              _viewTranscripts(
                                    visibleTranscripts[index],
                                    index,
                                    l10n,
                                  )
                                  .animate(delay: (index * 100).ms)
                                  .slideX(begin: 0.3)
                                  .fadeIn(),
                        ),
                    ],

                    const SliverToBoxAdapter(
                      child: SizedBox(height: PRFSpacingTokens.xxl),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewTranscripts(
    PRFTranscript transcript,
    int index,
    AppLocalizations l10n,
  ) {
    final media = transcript.media;
    final hasMedia = media != null;
    final hasTranscript = transcript.content.isNotEmpty;
    const actionButtonHeight = PRFSpacingTokens.xxxl;
    final recordedAt = hasMedia
        ? DateFormatter.formatDateTime(media.createdAt, timezone)
        : 'Syncing recording...';
    final fileSize = hasMedia ? media.humanReadableSize : '--';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  child: Icon(
                    Icons.audiotrack,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Text(
                    l10n.recordingItem(index + 1),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.sm,
                    vertical: PRFSpacingTokens.xs,
                  ),
                  decoration: BoxDecoration(
                    color: hasTranscript
                        ? Theme.of(context).colorScheme.primary.withValues(
                            alpha: 0.12,
                          )
                        : Theme.of(context).colorScheme.secondary.withValues(
                            alpha: 0.12,
                          ),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
                  ),
                  child: Text(
                    hasTranscript ? 'Ready' : 'Processing',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: hasTranscript
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.xs),
                Expanded(
                  child: Text(
                    recordedAt,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.xs),
            Row(
              children: [
                Icon(
                  Icons.sd_storage_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.xs),
                Text(
                  fileSize,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (hasTranscript) ...[
              const SizedBox(height: PRFSpacingTokens.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Text(
                  transcript.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: PRFSpacingTokens.md),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: actionButtonHeight,
                    child: hasMedia
                        ? BlocConsumer<DownloadFileCubit, DownloadFileState>(
                            listener: (context, state) {
                              state.mapOrNull(
                                loaded: (_) {
                                  PRFSnackbar.success(context, l10n.downloaded);
                                },
                              );
                            },
                            builder: (context, state) => PRFPrimaryButton(
                              onPressed: () => context
                                  .read<DownloadFileCubit>()
                                  .downloadFile(media.temporaryURL),
                              title: 'Download',
                              disabled: false,
                              isLoading: state.maybeWhen(
                                loading: () => true,
                                orElse: () => false,
                              ),
                            ),
                          )
                        : PRFPrimaryButton(
                            onPressed: () {},
                            title: 'Processing',
                            disabled: true,
                          ),
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.sm),
                Expanded(
                  child: SizedBox(
                    height: actionButtonHeight,
                    child: PRFSecondaryButton(
                      onPressed: hasTranscript
                          ? () async {
                              await _viewTranscript(transcript);
                            }
                          : () {},
                      title: hasTranscript ? l10n.viewTranscript : 'Processing',
                      disabled: !hasTranscript,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewTranscript(PRFTranscript transcript) async {
    await PRFBottomSheet.show<void>(
      context,
      title: context.l10n.viewTranscript,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
          child: Text(
            transcript.content,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );

    if (!mounted) return;
    await context.read<MissionSessionDetailsResourceCubit>().loadSession(
      missionSessionUlid: missionSessionUlid,
      refresh: true,
    );
  }
}

class _RecordingStatusCard extends StatelessWidget {
  const _RecordingStatusCard({
    required this.missionSessionUlid,
    required this.onOpenRecorder,
  });

  final String missionSessionUlid;
  final Future<void> Function() onOpenRecorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AudioRecordingCubit, AudioRecordingState>(
      builder: (context, state) {
        final (label, duration, isRecording, isPaused) = state.map(
          initial: (_) => ('Recorder idle', Duration.zero, false, false),
          ready: (_) => ('Recorder ready', Duration.zero, false, false),
          recording: (s) => ('Recording in progress', s.duration, true, false),
          paused: (s) => ('Recording paused', s.duration, false, true),
          completed: (s) => ('Saved locally', s.duration, false, false),
          error: (_) =>
              ('Recorder needs attention', Duration.zero, false, false),
        );

        if (!isRecording && !isPaused) {
          return const SizedBox.shrink();
        }

        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final mm = twoDigits(duration.inMinutes.remainder(60));
        final ss = twoDigits(duration.inSeconds.remainder(60));

        return Container(
          margin: const EdgeInsets.only(top: PRFSpacingTokens.sm),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: isRecording
                  ? theme.colorScheme.error.withValues(alpha: 0.4)
                  : theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isRecording ? Icons.fiber_manual_record : Icons.pause_circle,
                color: isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
              ),
              const SizedBox(width: PRFSpacingTokens.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$mm:$ss · You can keep browsing the app',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 96,
                child: PRFSecondaryButton(
                  onPressed: () async {
                    await onOpenRecorder();
                  },
                  title: 'Open',
                  disabled: false,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              if (isRecording)
                IconButton(
                  onPressed: () =>
                      context.read<AudioRecordingCubit>().pauseRecording(),
                  icon: const Icon(Icons.pause),
                )
              else
                IconButton(
                  onPressed: () =>
                      context.read<AudioRecordingCubit>().resumeRecording(),
                  icon: const Icon(Icons.play_arrow),
                ),
              IconButton(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().stopRecording(),
                icon: const Icon(Icons.stop),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MissionSessionDataView extends StatelessWidget with TimezoneMixin {
  const MissionSessionDataView({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;

  Future<void> _showEditSessionSheet(BuildContext context) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: SessionFormView(
          missionUlid: missionUlid,
          missionSession: missionSession,
        ),
      ),
    );
  }

  Future<void> _deleteSession(BuildContext context) async {
    final l10n = context.l10n;
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${l10n.delete} ${l10n.sessionDetails}',
      message: l10n.confirmDelete,
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (shouldDelete != true) return;
    if (!context.mounted) return;

    await context.read<MissionSessionResourceCubit>().deleteSession(
      missionSession.ulid,
    );
    if (!context.mounted) return;

    final error = context.read<MissionSessionResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );

    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }

    await context.read<MissionSessionDetailsResourceCubit>().loadSession(
      missionSessionUlid: missionSession.ulid,
      refresh: true,
    );
    if (!context.mounted) return;

    PRFSnackbar.success(context, l10n.sessionDeleted);
    context.router.back();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final startTime = DateFormatter.formatTimeFromDateTime(
      missionSession.startsAt,
      timezone,
    );
    final endTime = DateFormatter.formatTimeFromDateTime(
      missionSession.endsAt,
      timezone,
    );
    final timeRange =
        '$startTime '
        '- $endTime';
    final facilitator = missionSession.facilitator?.fullName ?? 'N/A';
    final notes = missionSession.notes.trim().isEmpty
        ? 'No notes available'
        : missionSession.notes.trim();

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Info Cards
            Padding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: PRFSectionHeader(
                          title: 'Session information',
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: PRFSecondaryButton(
                          onPressed: () async {
                            await _showEditSessionSheet(context);
                          },
                          title: l10n.edit,
                          disabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PRFInfoCard(
                        icon: Icons.access_time,
                        label: l10n.time,
                        value: timeRange,
                      ),
                      const SizedBox(height: PRFSpacingTokens.sm),
                      PRFInfoCard(
                        icon: Icons.person,
                        label: l10n.facilitator,
                        value: facilitator,
                      ),
                      if (missionSession.speaker != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PRFSpacingTokens.sm,
                          ),
                          child: PRFInfoCard(
                            icon: Icons.mic,
                            label: l10n.speaker,
                            value: missionSession.speaker!.fullName,
                          ),
                        ),
                      if (missionSession.classGroup != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PRFSpacingTokens.sm,
                          ),
                          child: PRFInfoCard(
                            icon: Icons.group,
                            label: l10n.classGroup,
                            value: missionSession.classGroup!.name,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(PRFSpacingTokens.md),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: PRFSpacingTokens.sm),
                            Text(
                              l10n.notes,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          notes,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: notes == 'No notes available'
                                    ? Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.6)
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: PRFSpacingTokens.md),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 140,
                      child: PRFDestroyButton(
                        onPressed: () async {
                          await _deleteSession(context);
                        },
                        title: l10n.delete,
                        disabled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: PRFMotionTokens.standard).slideY(begin: 0.2).fadeIn(),
    );
  }
}
