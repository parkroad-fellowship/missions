import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/actions/update_session/update_session.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/add_audio.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/media/prf_failed_recording_upload.dart';
import 'package:app/models/local/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

  Stream<PRFLocalMissionSession?> get _missionSessionStream =>
      getIt<IsarService>().missionSessions.itemStream;

  @override
  void initState() {
    super.initState();
    context.read<MissionSessionResourceCubit>().loadAll(
      filters: {'mission_session_ulid': missionSessionUlid},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    const defaultLoadingWidget = SliverToBoxAdapter(
      child: PRFCircularProgressIndicator(),
    );
    const defaultEmptyStateWidget = SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<MissionSessionResourceCubit>().loadAll(
            filters: {'mission_session_ulid': missionSessionUlid},
          ),
          child: CustomScrollView(
            slivers: [
              // Navigation Header
              PRFNavBar(
                onBack: () => context.router.back(),
                title: l10n.sessionDetails,
              ),
              // Upload Status
              SliverToBoxAdapter(
                child: BlocConsumer<UploadMediaCubit, UploadMediaState>(
                  listener: (context, state) {
                    state.mapOrNull(
                      loaded: (_) {
                        context.read<MissionSessionResourceCubit>().loadAll(
                          filters: {'mission_session_ulid': missionSessionUlid},
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
                        child: LinearProgressIndicator(),
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
                      MissionSessionResourceCubit,
                      ResourceState<PRFMissionSession>
                    >(
                      builder: (context, state) => state.maybeWhen(
                        listLoading: () => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.lg,
                          ),
                          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                          ),
                          child: const Center(
                            child: LinearProgressIndicator(),
                          ),
                        ),
                        error: (message, _) => Container(
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

              // Session Data
              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) => MissionSessionDataView(
                  missionSession: missionSession!,
                  missionUlid: widget.missionUlid,
                ),
              ),

              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) => const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xl),
                ),
              ),

              // Recordings Section
              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) => SliverToBoxAdapter(
                  child:
                      Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.md,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.audiotrack_outlined,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  size: 24,
                                ),
                                const SizedBox(width: PRFSpacingTokens.md),
                                Expanded(
                                  child: Text(
                                    l10n.recordings,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onPrimary.withValues(
                                          alpha: 0.2,
                                        ),
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.sm,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                    onPressed: () => WoltModalSheet.show<void>(
                                      context: context,
                                      pageListBuilder: (modalSheetContext) {
                                        return [
                                          WoltModalSheetPage(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            child: SizedBox(
                                              height:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).height *
                                                  0.8,
                                              child: AddAudioView(
                                                missionSessionUlid:
                                                    missionSessionUlid,
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate(delay: PRFMotionTokens.slow)
                          .slideY(begin: 0.2)
                          .fadeIn(),
                ),
              ),

              // Pending / queued recordings for this session
              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) =>
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
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
                                    const SizedBox(width: PRFSpacingTokens.sm),
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
                                    TextButton(
                                      onPressed: () =>
                                          getIt<FailedRecordingUploadService>()
                                              .retryAllUploadsForSession(
                                                missionSessionUlid,
                                              ),
                                      child: const Text('Retry all'),
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
                                                overflow: TextOverflow.ellipsis,
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
                                        TextButton(
                                          onPressed: () =>
                                              getIt<
                                                    FailedRecordingUploadService
                                                  >()
                                                  .retrySpecificUpload(upload),
                                          child: const Text('Retry'),
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
              ),

              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) => const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.lg),
                ),
              ),

              // Recordings List
              SingleStreamWrapper(
                stream: _missionSessionStream,
                nullWidget: defaultEmptyStateWidget,
                loading: defaultLoadingWidget,
                widget: (context, missionSession) =>
                    missionSession!.transcripts.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child:
                              Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  .fadeIn(duration: PRFMotionTokens.enterShort)
                                  .scale(begin: const Offset(0.8, 0.8)),
                        ),
                      )
                    : SliverList.builder(
                        itemCount: missionSession.transcripts.length,
                        itemBuilder: (context, index) =>
                            _viewTranscripts(
                                  missionSession.transcripts.reversed
                                      .toList()[index],
                                  index,
                                  l10n,
                                )
                                .animate(delay: (index * 100).ms)
                                .slideX(begin: 0.3)
                                .fadeIn(),
                      ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: PRFSpacingTokens.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewTranscripts(
    PRFLocalMissionSessionTranscript transcript,
    int index,
    AppLocalizations l10n,
  ) => Container(
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
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Row(
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
          Text(
            l10n.recordingItem(index + 1),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(PRFSpacingTokens.lg),
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.download_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  l10n.downloadTeaching(transcript.media!.humanReadableSize!),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  DateFormatter.formatDateTime(
                    transcript.media!.createdAt!,
                    timezone,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: BlocConsumer<DownloadFileCubit, DownloadFileState>(
                  listener: (context, state) {
                    state.mapOrNull(
                      loaded: (_) {
                        PRFSnackbar.success(context, l10n.downloaded);
                      },
                    );
                  },
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => SizedBox(
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.sm,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.download,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () =>
                              context.read<DownloadFileCubit>().downloadFile(
                                transcript.media!.temporaryURL!,
                              ),
                        ),
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 48,
                      height: 48,
                      child: PRFCircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              if (transcript.content?.isEmpty ?? false)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.md,
                    vertical: PRFSpacingTokens.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      Expanded(
                        child: Text(
                          l10n.transcriptProcessing,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l10n.inTesting,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (transcript.content?.isNotEmpty ?? true)
                GestureDetector(
                  onTap: () => _viewTranscript(transcript),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.md,
                      vertical: PRFSpacingTokens.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.text_snippet_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: PRFSpacingTokens.sm),
                        Expanded(
                          child: Text(
                            l10n.viewTranscript,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.inTesting,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                        const SizedBox(width: PRFSpacingTokens.sm),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  void _viewTranscript(PRFLocalMissionSessionTranscript transcript) =>
      WoltModalSheet.show<void>(
        context: context,
        pageListBuilder: (modalSheetContext) {
          return [
            WoltModalSheetPage(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.lg,
                  ),
                  child: Text(
                    transcript.content!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          ];
        },
      ).then((_) {
        // ignore: use_build_context_synchronously
        context.read<MissionSessionResourceCubit>().loadAll(
          filters: {'mission_session_ulid': missionSessionUlid},
        );
      });
}

class MissionSessionDataView extends StatelessWidget with TimezoneMixin {
  const MissionSessionDataView({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFLocalMissionSession missionSession;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              padding: const EdgeInsets.all(PRFSpacingTokens.xl),
              child: Column(
                children: [
                  _buildInfoCard(
                    context,
                    Icons.access_time,
                    l10n.time,
                    // ignore: lines_longer_than_80_chars
                    '${DateFormatter.formatTimeFromDateTime(missionSession.startsAt, timezone)} '
                    // ignore: lines_longer_than_80_chars
                    '- ${DateFormatter.formatTimeFromDateTime(missionSession.endsAt, timezone)}',
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  _buildInfoCard(
                    context,
                    Icons.person,
                    l10n.facilitator,
                    missionSession.facilitator.fullName!,
                  ),
                  if (missionSession.speaker != null) ...[
                    const SizedBox(height: PRFSpacingTokens.md),
                    _buildInfoCard(
                      context,
                      Icons.mic,
                      l10n.speaker,
                      missionSession.speaker!.fullName ?? 'N/A',
                    ),
                  ],
                  if (missionSession.classGroup != null) ...[
                    const SizedBox(height: PRFSpacingTokens.md),
                    _buildInfoCard(
                      context,
                      Icons.group,
                      l10n.classGroup,
                      missionSession.classGroup!.name ?? 'N/A',
                    ),
                  ],
                  const SizedBox(height: PRFSpacingTokens.xl),

                  // Notes Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: PRFSpacingTokens.md),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(PRFSpacingTokens.md),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.sm,
                            ),
                          ),
                          child: Text(
                            missionSession.notes.isNotEmpty
                                ? missionSession.notes
                                : 'No notes available',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: missionSession.notes.isNotEmpty
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: PRFSpacingTokens.xl),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => WoltModalSheet.show<void>(
                              context: context,
                              pageListBuilder: (modalSheetContext) {
                                return [
                                  WoltModalSheetPage(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          0.8,
                                      child: UpdateSessionView(
                                        missionUlid: missionUlid,
                                        missionSession: missionSession,
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: PRFSpacingTokens.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.smd,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            label: Text(
                              l10n.edit,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.lg),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.smd,
                            ),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () async => showDialog<void>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(l10n.deleteSession),
                                  content: Text(l10n.confirmDelete),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(l10n.cancel),
                                    ),
                                    BlocConsumer<
                                      MissionSessionResourceCubit,
                                      ResourceState<PRFMissionSession>
                                    >(
                                      listener: (context, state) {
                                        state.mapOrNull(
                                          mutated: (_) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            context
                                                .read<
                                                  MissionSessionResourceCubit
                                                >()
                                                .loadAll(
                                                  filters: {
                                                    'mission_ulid': missionUlid,
                                                  },
                                                );
                                            PRFSnackbar.success(
                                              context,
                                              l10n.sessionDeleted,
                                            );
                                          },
                                          error: (e) {
                                            Navigator.of(context).pop();
                                            PRFSnackbar.error(
                                              context,
                                              e.message,
                                            );
                                          },
                                        );
                                      },
                                      builder: (context, state) {
                                        return TextButton(
                                          onPressed: () {
                                            context
                                                .read<
                                                  MissionSessionResourceCubit
                                                >()
                                                .deleteSession(
                                                  missionSession.ulid,
                                                );
                                          },
                                          child: Text(l10n.delete),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: PRFSpacingTokens.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.smd,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            label: Text(
                              l10n.delete,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: PRFMotionTokens.standard).slideY(begin: 0.2).fadeIn(),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
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
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.xs),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
