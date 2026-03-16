import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/live_recording_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/pending_uploads_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/media/prf_failed_recording_upload.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    getIt<FailedRecordingUploadService>().streamPendingUploads();
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
        // Pending uploads widget
        PendingUploadsWidget(
          missionSessionUlid: widget.missionSessionUlid,
        ),

        // Local queued recordings preview
        StreamBuilder<List<PRFFailedRecordingUpload>>(
          stream: getIt<FailedRecordingUploadService>().pendingUploadsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final sessionUploads = snapshot.data!
                .where(
                  (upload) => upload.modelUlid == widget.missionSessionUlid,
                )
                .toList();

            if (sessionUploads.isEmpty) return const SizedBox.shrink();

            final uploadsToShow = sessionUploads.take(3).toList();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
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
                        Icons.library_music_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Queued recordings',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (sessionUploads.length > uploadsToShow.length)
                        Text(
                          '+${sessionUploads.length - uploadsToShow.length} '
                          'more',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...uploadsToShow.map(
                    (upload) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.audiotrack,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              upload.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Chip(
                            label: Text('Queued'),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        BlocConsumer<RecordingUploadCubit, RecordingUploadState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              loaded: (uploadedFile) {
                PRFSnackbar.success(
                  context,
                  '${l10n.upload} ${l10n.recordingCompleted}',
                );
                context.read<GetMissionSessionCubit>().getMissionSession(
                  missionSessionUlid: widget.missionSessionUlid,
                  refresh: true,
                );
                Navigator.of(context).pop();
              },
              multipleLoaded: (uploadedFiles) {
                PRFSnackbar.success(
                  context,
                  '${uploadedFiles.length}'
                  ' ${l10n.recordings} ${l10n.upload}',
                );
                // Close the modal after successful upload
                Navigator.of(context).pop();
              },
              error: (message) {
                PRFSnackbar.info(
                  context,
                  'You are offline. '
                  'The app will retry when you are back online. '
                  'You can continue using the app.',
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
                                name: StringFormatter.getFileName(file.path),
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
