import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/live_recording_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/pending_uploads_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:app/utils/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddAudioViewHandset extends StatefulWidget {
  const AddAudioViewHandset({required this.missionSessionUlid, super.key});

  final String missionSessionUlid;

  @override
  State<AddAudioViewHandset> createState() => _AddAudioViewHandsetState();
}

class _AddAudioViewHandsetState extends State<AddAudioViewHandset>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<SelectMediaCubit>().clearMedia();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: .2),
            ),
          ),
          child: TabBar(
            tabAlignment: TabAlignment.center,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                icon: const Icon(Icons.mic),
                text: l10n.liveRecording,
              ),
              Tab(
                icon: const Icon(Icons.upload_file),
                text: l10n.uploadRecording,
              ),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Live Recording Tab
              _buildLiveRecordingTab(context, l10n),

              // Upload Files Tab
              _buildUploadFilesTab(context, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadFilesTab(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<SelectMediaCubit, SelectMediaState>(
                builder: (context, state) => state.when(
                  initial: () => ListTile(
                    title: Text(
                      l10n.tapToAdd,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    leading: const Icon(
                      Icons.speaker,
                      size: 32,
                      color: Color(0xffc4c4c4),
                    ),
                    onTap: () =>
                        context.read<SelectMediaCubit>().selectAudioFiles(
                          model: PRFMediaModel.missionSessionAudios,
                          modelUlid: widget.missionSessionUlid,
                        ),
                  ),
                  empty: () => ListTile(
                    title: Text(
                      l10n.tapToAdd,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    leading: const Icon(
                      Icons.speaker,
                      size: 32,
                      color: Color(0xffc4c4c4),
                    ),
                    onTap: () =>
                        context.read<SelectMediaCubit>().selectAudioFiles(
                          model: PRFMediaModel.missionSessionAudios,
                          modelUlid: widget.missionSessionUlid,
                        ),
                  ),
                  loaded: (files) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(
                                Icons.audio_file,
                                color: Color(0xffc4c4c4),
                              ),
                              title: Text(
                                files[index].name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        PRFSecondaryButton(
                          onPressed: () =>
                              context.read<SelectMediaCubit>().selectAudioFiles(
                                model: PRFMediaModel.missionSessionAudios,
                                modelUlid: widget.missionSessionUlid,
                                previousMedia: files,
                              ),
                          title: l10n.addMore,
                          disabled: false,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<SelectMediaCubit, SelectMediaState>(
                builder: (context, state) {
                  final isDisabled = state.maybeWhen(
                    loaded: (media) => media.isEmpty,
                    orElse: () => true,
                  );

                  return PRFPrimaryButton(
                    title: l10n.upload,
                    disabled: isDisabled,
                    onPressed: isDisabled
                        ? () {}
                        : () async {
                            Navigator.of(context).pop(); // Close the dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.willUpload)),
                            );
                            await context
                                .read<UploadMediaCubit>()
                                .uploadMedia();
                          },
                  );
                },
              ),
              const SizedBox(height: 16),
              PRFSecondaryButton(
                title: l10n.cancel,
                disabled: false,
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  context.read<SelectMediaCubit>().clearMedia();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveRecordingTab(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Pending uploads widget
        PendingUploadsWidget(
          failedUploadService: GetIt.instance<FailedRecordingUploadService>(),
        ),

        BlocConsumer<RecordingUploadCubit, RecordingUploadState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              loaded: (uploadedFile) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.upload} ${l10n.recordingCompleted}'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                context.read<GetMissionSessionCubit>().getMissionSession(
                  missionSessionUlid: widget.missionSessionUlid,
                  refresh: true,
                );
                Navigator.of(context).pop();
              },
              multipleLoaded: (uploadedFiles) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${uploadedFiles.length}'
                      ' ${l10n.recordings} ${l10n.upload}',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                // Close the modal after successful upload
                Navigator.of(context).pop();
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.recordingError}: $message'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
            );
          },
          builder: (context, state) => state.maybeWhen(
            loading: () => Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${l10n.upload}...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ),

        // Live Recording Widget
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth.isFinite
                        ? constraints.maxWidth
                        : MediaQuery.of(context).size.width - 32,
                    maxHeight: constraints.maxHeight.isFinite
                        ? constraints.maxHeight
                        : MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: LiveRecordingWidget(
                    onRecordingCompleted: (filePath, duration) async {
                      final file = File(filePath);
                      if (file.existsSync()) {
                        await context
                            .read<RecordingUploadCubit>()
                            .uploadRecording(
                              PRFMediaDTO(
                                model:
                                    PRFMediaModel.missionSessionLiveRecordings,
                                modelUlid: widget.missionSessionUlid,
                                path: file.path,
                                name: Misc.getFileName(file.path),
                              ),
                            );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
