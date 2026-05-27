import 'dart:io';

import 'package:app/di/di_container.dart';
import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/media/failed_recording_upload_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:app/shared/media_upload/cubit/recording_upload_cubit.dart';
import 'package:app/shared/media_upload/widgets/live_recording_widget.dart';
import 'package:app/shared/media_upload/widgets/pending_uploads_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class OfflineAudioRecorderSheet extends StatelessWidget {
  const OfflineAudioRecorderSheet({
    required this.model,
    required this.modelUlid,
    super.key,
  });

  final PRFMediaModel model;
  final String modelUlid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordingUploadCubit>(
      create: (context) => RecordingUploadCubit(
        mediaService: getIt<MediaService>(),
        failedUploadService: getIt<FailedRecordingUploadService>(),
        hiveService: getIt<HiveService>(),
      ),
      child: BlocConsumer<RecordingUploadCubit, RecordingUploadState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            loaded: (_) {
              PRFSnackbar.success(context, 'Answer uploaded');
              Navigator.of(context).pop();
            },
            multipleLoaded: (_) {},
            error: (_) {
              PRFSnackbar.info(
                context,
                'Saved offline. The app will upload when you are back online.',
              );
            },
          );
        },
        builder: (context, uploadState) {
          final isUploading = uploadState.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Column(
            children: [
              PendingUploadsWidget(
                model: model,
                modelUlid: modelUlid,
              ),
              if (isUploading)
                Container(
                  margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                  padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: PRFSpacingTokens.xl,
                        height: 20,
                        child: PRFCircularProgressIndicator(),
                      ),
                      const SizedBox(width: PRFSpacingTokens.md),
                      Text(
                        'Uploading...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                  child: LiveRecordingWidget(
                    onMinimize: () {
                      Navigator.of(context).pop();
                      PRFSnackbar.info(
                        context,
                        'Recording continues in the background.',
                      );
                    },
                    onRecordingCompleted: (filePath, duration) async {
                      final file = File(filePath);
                      if (!file.existsSync()) return;

                      await context
                          .read<RecordingUploadCubit>()
                          .uploadRecording(
                            PRFMediaDTO(
                              model: model,
                              modelUlid: modelUlid,
                              path: file.path,
                              name: StringFormatter.getFileName(file.path),
                            ),
                          );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
