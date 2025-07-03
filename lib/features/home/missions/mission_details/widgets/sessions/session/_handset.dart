import 'package:app/features/home/missions/cubit/delete_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/add_audio.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/widgets/data_card.dart';
import 'package:app/features/home/missions/mission_details/widgets/update_session/update_session.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_mission_session.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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

class _SessionPageHandsetState extends State<SessionPageHandset> {
  int get missionSessionId => widget.missionSessionId;
  String get missionSessionUlid => widget.missionSessionUlid;
  String get missionUlid => widget.missionUlid;

  Stream<PRFLocalMissionSession> get _missionSessionStream =>
      getIt<LocalDBService>().missionSession;

  @override
  void initState() {
    super.initState();
    context.read<GetMissionSessionCubit>().getMissionSession(
      missionSessionUlid: missionSessionUlid,
      missionUlid: missionUlid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    Misc.initDimensions(context);

    const defaultLoadingWidget = SliverToBoxAdapter(
      child: PRFCircularProgressIndicator(),
    );
    const defaultEmptyStateWidget = SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<GetMissionSessionCubit>().getMissionSession(
                missionSessionUlid: missionSessionUlid,
                missionUlid: missionUlid,
                refresh: true,
              ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomScrollView(
              slivers: [
                // Start Navigation Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.w,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            padding: const EdgeInsets.only(left: 8),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.sessionDetails,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                // End Navigation Bar
                SliverToBoxAdapter(child: SizedBox(height: 48.h)),
                SliverToBoxAdapter(
                  child: BlocConsumer<UploadMediaCubit, UploadMediaState>(
                    listener: (context, state) {
                      state.mapOrNull(
                        loaded: (_) {
                          context
                              .read<GetMissionSessionCubit>()
                              .getMissionSession(
                                missionSessionUlid: missionSessionUlid,
                                missionUlid: missionUlid,
                                refresh: true,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.doneUploading)),
                          );
                        },
                        error: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                        },
                      );
                    },
                    builder: (context, state) => state.maybeWhen(
                      loading: () => const Center(
                        child: LinearProgressIndicator(),
                      ),
                      error: (message) => Center(child: Text(message)),
                      orElse: () => const SizedBox(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      BlocBuilder<
                        GetMissionSessionCubit,
                        GetMissionSessionState
                      >(
                        builder: (context, state) => state.maybeWhen(
                          loading: () => const Center(
                            child: LinearProgressIndicator(),
                          ),
                          error: (message) => Center(child: Text(message)),
                          orElse: () => const SizedBox(),
                        ),
                      ),
                ),
                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) => MissionSessionDataView(
                    missionSession: missionSession,
                    missionUlid: widget.missionUlid,
                  ),
                ),
                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) =>
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ),

                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) => const SliverToBoxAdapter(
                    child: Divider(thickness: 2),
                  ),
                ),

                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) =>
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ),
                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) => SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FormFieldLabel(
                            label: l10n.recordings,

                            isBold: true,
                          ),
                          SizedBox(
                            width: 500.w,
                            child: PRFPrimaryButton(
                              title: l10n.uploadRecording,
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
                              disabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) =>
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ),
                SingleStreamWrapper(
                  stream: _missionSessionStream,
                  nullWidget: defaultEmptyStateWidget,
                  loading: defaultLoadingWidget,
                  widget: (context, missionSession) =>
                      missionSession.transcripts.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              l10n.noRecordings,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        )
                      : SliverList.builder(
                          itemCount: missionSession.transcripts.length,
                          itemBuilder: (context, index) => _viewTranscripts(
                            missionSession.transcripts[index],
                            index,
                            l10n,
                          ),
                        ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewTranscripts(
    PRFLocalMissionSessionTranscript transcript,
    int index,
    AppLocalizations l10n,
  ) => ExpansionTile(
    initiallyExpanded: true,
    title: Text(l10n.recordingItem(index + 1)),
    expandedAlignment: Alignment.centerLeft,
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        title: Text(
          l10n.downloadTeaching,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: BlocConsumer<DownloadFileCubit, DownloadFileState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.downloaded)));
                },
              );
            },
            builder: (context, state) => state.maybeWhen(
              orElse: () => const Icon(Icons.download),
              loading: PRFCircularProgressIndicator.new,
            ),
          ),
          onPressed: () => context.read<DownloadFileCubit>().downloadFile(
            transcript.media!.temporaryURL!,
          ),
        ),
      ),
      if (transcript.content?.isEmpty ?? false)
        Badge(
          label: Text(l10n.inTesting),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Chip(
            backgroundColor: Colors.white,
            label: Text(
              l10n.transcriptProcessing,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      if (transcript.content?.isNotEmpty ?? true)
        Badge(
          label: Text(l10n.inTesting),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: GestureDetector(
            onTap: () => _viewTranscript(transcript),
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                l10n.viewTranscript,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
    ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
        context.read<GetMissionSessionCubit>().getMissionSession(
          missionSessionUlid: missionSessionUlid,
          missionUlid: missionUlid,
        );
      });
}

class MissionSessionDataView extends StatelessWidget {
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

    return SliverList(
      delegate: SliverChildListDelegate([
        DataCard(
          label: l10n.time,
          value:
              '${DateFormat.jm().format(missionSession.startsAt)} -'
              ' ${DateFormat.jm().format(missionSession.endsAt)}',
        ),
        DataCard(
          label: l10n.facilitator,
          value: missionSession.facilitator.fullName!,
        ),
        if (missionSession.speaker != null)
          DataCard(
            label: l10n.speaker,
            value: missionSession.speaker!.fullName ?? 'N/A',
          ),
        if (missionSession.classGroup != null)
          DataCard(
            label: l10n.classGroup,
            value: missionSession.classGroup!.name ?? 'N/A',
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: FormFieldLabel(label: l10n.notes, isBold: true),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: PRFTextAreaInput(
                hintText: '',
                controller: TextEditingController(text: missionSession.notes),
                enabled: false,
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PRFPrimaryButton(
                title: l10n.edit,
                onPressed: () => WoltModalSheet.show<void>(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    return [
                      WoltModalSheetPage(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.8,
                          child: UpdateSessionView(
                            missionUlid: missionUlid,
                            missionSession: missionSession,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
                disabled: false,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: PRFDestroyButton(
                title: l10n.delete,
                disabled: false,
                onPressed: () async => showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.deleteSession),
                      content: Text(l10n.confirmDelete),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
                        ),
                        BlocConsumer<
                          DeleteMissionSessionCubit,
                          DeleteMissionSessionState
                        >(
                          listener: (context, state) {
                            state.mapOrNull(
                              loaded: (_) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                context
                                    .read<GetMissionSessionsCubit>()
                                    .getMissionSessions(
                                      missionUlid: missionUlid,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.sessionDeleted),
                                  ),
                                );
                              },
                              error: (e) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              },
                            );
                          },
                          builder: (context, state) {
                            return TextButton(
                              onPressed: () {
                                context
                                    .read<DeleteMissionSessionCubit>()
                                    .deleteMissionSession(
                                      missionSessionUlid: missionSession.ulid,
                                    );
                              },
                              child: state.maybeWhen(
                                orElse: () => Text(l10n.delete),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
