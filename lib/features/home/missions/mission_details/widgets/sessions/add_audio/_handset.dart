import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/live_recording_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/pending_uploads_widget.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                    content: Text(
                      'You are offline. '
                      'The app will retry when you are back online. '
                      'You can continue using the app.',
                    ),
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
                    onRecordingCompleted:
                        (String filePath, Duration duration) async {
                          final file = File(filePath);
                          if (file.existsSync()) {
                            await context
                                .read<RecordingUploadCubit>()
                                .uploadRecording(
                                  PRFMediaDTO(
                                    model: PRFMediaModel
                                        .missionSessionLiveRecordings,
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
