import 'package:app/features/home/missions/cubit/delete_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/add_audio.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/update_session/update_session.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SessionPageHandset extends StatefulWidget {
  const SessionPageHandset({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;

  @override
  State<SessionPageHandset> createState() => _SessionPageHandsetState();
}

class _SessionPageHandsetState extends State<SessionPageHandset> {
  PRFMissionSession? _missionSession;

  @override
  void initState() {
    super.initState();

    _missionSession = widget.missionSession;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
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
                            color: PRFApp.theme().kPrimaryColorV2,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => context.router.popForced(),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.sessionDetails,
                        style: PRFText.theme().displayLarge?.copyWith(
                          fontSize: 80.sp,
                        ),
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
                              missionSessionUlid: _missionSession!.ulid,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.doneUploading)),
                        );
                      },
                      error: (error) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error.message)));
                      },
                    );
                  },
                  builder:
                      (context, state) => state.maybeWhen(
                        loading:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => Center(child: Text(message)),
                        orElse: () => const SizedBox(),
                      ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocConsumer<
                  GetMissionSessionCubit,
                  GetMissionSessionState
                >(
                  listener: (context, state) {
                    state.mapOrNull(
                      loaded: (result) {
                        setState(() {
                          _missionSession = result.missionSession;
                        });
                      },
                    );
                  },
                  builder:
                      (context, state) => state.maybeWhen(
                        loading:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => Center(child: Text(message)),
                        orElse: () => const SizedBox(),
                      ),
                ),
              ),
              if (_missionSession != null)
                MissionSessionDataView(
                  missionSession: _missionSession!,
                  missionUlid: widget.missionUlid,
                ),
              if (_missionSession != null)
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (_missionSession != null)
                const SliverToBoxAdapter(child: Divider(thickness: 2)),
              if (_missionSession != null)
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (_missionSession != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FormFieldLabel(
                          label: l10n.recordings,
                          color: PRFApp.theme().kBlackColor,
                          isBold: true,
                        ),
                        SizedBox(
                          width: 500.w,
                          child: PrimaryButton(
                            title: l10n.uploadRecording,
                            onPressed:
                                () => WoltModalSheet.show<void>(
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
                                                _missionSession!.ulid,
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
              if (_missionSession != null)
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (_missionSession != null)
                if (_missionSession!.transcripts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        l10n.noRecordings,
                        style: PRFText.theme().bodySmall,
                      ),
                    ),
                  ),

              if (_missionSession != null)
                SliverList.builder(
                  itemCount: _missionSession!.transcripts.length,
                  itemBuilder: (context, index) {
                    final transcript = _missionSession!.transcripts[index];
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(l10n.recordingItem(++index)),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            l10n.downloadTeaching,
                            style: PRFText.theme().bodySmall,
                          ),
                          trailing: IconButton(
                            icon: BlocConsumer<
                              DownloadFileCubit,
                              DownloadFileState
                            >(
                              listener: (context, state) {
                                state.mapOrNull(
                                  loaded: (_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.downloaded)),
                                    );
                                  },
                                );
                              },
                              builder:
                                  (context, state) => state.maybeWhen(
                                    orElse: () => const Icon(Icons.download),
                                    loading: PRFCircularProgressIndicator.new,
                                  ),
                            ),
                            onPressed:
                                () => context
                                    .read<DownloadFileCubit>()
                                    .downloadFile(
                                      transcript.media!.temporaryURL,
                                    ),
                          ),
                        ),
                        if (transcript.content.isEmpty)
                          Badge(
                            label: Text(l10n.inTesting),
                            backgroundColor: PRFApp.theme().kPrimaryColorV2,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Chip(
                              backgroundColor: Colors.white,
                              label: Text(
                                l10n.transcriptProcessing,
                                style: PRFText.theme().bodySmall,
                              ),
                            ),
                          ),
                        if (transcript.content.isNotEmpty)
                          Badge(
                            label: Text(l10n.inTesting),
                            backgroundColor: PRFApp.theme().kPrimaryColorV2,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(
                              onTap:
                                  () => WoltModalSheet.show<void>(
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              child: Text(
                                                transcript.content,
                                                style:
                                                    PRFText.theme().bodySmall,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                              child: Chip(
                                backgroundColor: Colors.white,
                                label: Text(
                                  l10n.viewTranscript,
                                  style: PRFText.theme().bodySmall,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class MissionSessionDataView extends StatelessWidget {
  const MissionSessionDataView({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionSession missionSession;
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
          value: missionSession.facilitator!.fullName,
        ),
        if (missionSession.speaker != null)
          DataCard(
            label: l10n.speaker,
            value: missionSession.speaker!.fullName,
          ),
        if (missionSession.classGroup != null)
          DataCard(
            label: l10n.classGroup,
            value: missionSession.classGroup!.name,
          ),
        DataCard(label: l10n.notes, value: missionSession.notes),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PrimaryButton(
                title: l10n.edit,
                onPressed:
                    () => WoltModalSheet.show<void>(
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
                    ).then((_) {
                      if (context.mounted) {
                        context
                            .read<GetMissionSessionCubit>()
                            .getMissionSession(
                              missionSessionUlid: missionSession.ulid,
                            );
                      }
                    }),
                disabled: false,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: PrimaryButton(
                isAlert: true,
                title: l10n.delete,
                disabled: false,
                onPressed:
                    () async => showDialog<void>(
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
                                          missionSessionUlid:
                                              missionSession.ulid,
                                        );
                                  },
                                  child: state.maybeWhen(
                                    orElse: () => Text(l10n.delete),
                                    loading:
                                        () => const CircularProgressIndicator(),
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

class DataCard extends StatelessWidget {
  const DataCard({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormFieldLabel(
            label: label,
            color: PRFApp.theme().kBlackColor,
            isBold: true,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: InputFormField(
            hintText: '',
            controller: TextEditingController(text: value),
            isUnderLine: true,
            enabled: false,
            maxLines: 15,
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
