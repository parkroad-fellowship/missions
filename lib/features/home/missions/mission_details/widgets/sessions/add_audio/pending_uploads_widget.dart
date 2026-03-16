// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars

import 'package:app/di/_index.dart';
import 'package:app/models/local/media/prf_failed_recording_upload.dart';
import 'package:app/models/local/media/upload_retry_progress.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PendingUploadsWidget extends StatefulWidget {
  const PendingUploadsWidget({
    required this.missionSessionUlid,
    super.key,
  });

  final String missionSessionUlid;

  @override
  State<PendingUploadsWidget> createState() => _PendingUploadsWidgetState();
}

class _PendingUploadsWidgetState extends State<PendingUploadsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PRFFailedRecordingUpload>>(
      stream: getIt<FailedRecordingUploadService>().pendingUploadsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        // Filter pending uploads by this mission session ULID
        final allPendingUploads = snapshot.data!;
        final sessionUploads = allPendingUploads
            .where((upload) => upload.modelUlid == widget.missionSessionUlid)
            .toList();

        if (sessionUploads.isEmpty) {
          return StreamBuilder<UploadRetryProgress>(
            stream: getIt<FailedRecordingUploadService>().retryProgressStream,
            builder: (context, progressSnapshot) {
              final progress =
                  progressSnapshot.data ?? UploadRetryProgress.idle;

              if (progress.isComplete) {
                return _buildSuccessMessage(context);
              }

              return Container(
                margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_done,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: Text(
                        'No pending uploads for this session',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return StreamBuilder<UploadRetryProgress>(
          stream: getIt<FailedRecordingUploadService>().retryProgressStream,
          builder: (context, progressSnapshot) {
            final progress = progressSnapshot.data ?? UploadRetryProgress.idle;

            return Container(
              margin: const EdgeInsets.all(PRFSpacingTokens.lg),
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      Expanded(
                        child: Text(
                          'Pending Uploads',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showPendingUploadsDetails(
                          context,
                          sessionUploads,
                        ),
                        child: Text(
                          '${sessionUploads.length} '
                          '${sessionUploads.length == 1 ? 'recording' : 'record'
                                    'ings'}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),

                  // Progress indicator
                  if (progress.isRetrying) ...[
                    _buildProgressIndicator(context, progress),
                    const SizedBox(height: PRFSpacingTokens.md),
                  ] else ...[
                    Text(
                      'Recordings will retry automatically '
                      'when you come online',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: progress.isRetrying
                              ? null
                              : () => _retryAllUploads(context),
                          icon: progress.isRetrying
                              ? const SizedBox(
                                  width: PRFSpacingTokens.lg,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 16),
                          label: Text(
                            progress.isRetrying ? 'Uploading...' : 'Retry Now',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                              vertical: PRFSpacingTokens.sm,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      OutlinedButton.icon(
                        onPressed: progress.isRetrying
                            ? null
                            : () => _showPendingUploadsDetails(
                                context,
                                sessionUploads,
                              ),
                        icon: const Icon(Icons.list, size: 16),
                        label: const Text('View All'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.lg,
                            vertical: PRFSpacingTokens.sm,
                          ),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _retryAllUploads(BuildContext context) async {
    try {
      // Get current pending uploads for this session
      final pendingUploads = await getIt<FailedRecordingUploadService>()
          .getPendingUploadsForSession(widget.missionSessionUlid);

      if (pendingUploads.isEmpty) {
        PRFSnackbar.info(context, 'No pending uploads for this session');
        return;
      }

      await getIt<FailedRecordingUploadService>().retryAllUploadsForSession(
        widget.missionSessionUlid,
      );
    } catch (e) {
      if (mounted) {
        PRFSnackbar.error(
          context,
          'Some uploads failed to retry. Please try again.',
        );
      }
    }
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    UploadRetryProgress progress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                progress.progressText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(progress.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.xs),
        LinearProgressIndicator(
          value: progress.progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        if (progress.currentFileName != null) ...[
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            'Uploading: ${progress.currentFileName}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(PRFSpacingTokens.lg),
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: PRFSpacingTokens.sm),
          Expanded(
            child: Text(
              'All uploads completed successfully!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingUploadsDetails(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            navBarHeight: 8,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: SizedBox(
              height:
                  MediaQuery.sizeOf(
                    context,
                  ).height *
                  0.6,
              child: Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pending Uploads',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        StreamBuilder<UploadRetryProgress>(
                          stream: getIt<FailedRecordingUploadService>()
                              .retryProgressStream,
                          builder: (context, progressSnapshot) {
                            final progress =
                                progressSnapshot.data ??
                                UploadRetryProgress.idle;

                            return TextButton.icon(
                              onPressed: progress.isRetrying
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                      _retryAllUploads(context);
                                    },
                              icon: progress.isRetrying
                                  ? const SizedBox(
                                      width: PRFSpacingTokens.lg,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                              label: Text(
                                progress.isRetrying
                                    ? 'Uploading...'
                                    : 'Retry All',
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Progress indicator in modal
                    StreamBuilder<UploadRetryProgress>(
                      stream: getIt<FailedRecordingUploadService>()
                          .retryProgressStream,
                      builder: (context, progressSnapshot) {
                        final progress =
                            progressSnapshot.data ?? UploadRetryProgress.idle;

                        if (progress.isRetrying) {
                          return Column(
                            children: [
                              const SizedBox(height: PRFSpacingTokens.sm),
                              _buildProgressIndicator(context, progress),
                              const SizedBox(height: PRFSpacingTokens.lg),
                            ],
                          );
                        }
                        return const SizedBox(height: PRFSpacingTokens.lg);
                      },
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: pendingUploads.length,
                        itemBuilder: (context, index) {
                          final upload = pendingUploads[index];
                          return _buildUploadItem(context, upload);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildUploadItem(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return StreamBuilder<UploadRetryProgress>(
      stream: getIt<FailedRecordingUploadService>().retryProgressStream,
      builder: (context, progressSnapshot) {
        final progress = progressSnapshot.data ?? UploadRetryProgress.idle;
        final isCurrentlyUploading =
            progress.isRetrying && progress.currentFileName == upload.name;

        return Container(
          margin: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            border: Border.all(
              color: isCurrentlyUploading
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
              width: isCurrentlyUploading ? 1.5 : 1,
            ),
            color: isCurrentlyUploading
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: isCurrentlyUploading
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isCurrentlyUploading ? 8 : 4,
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
                        color: isCurrentlyUploading
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.15)
                            : Theme.of(context).colorScheme.surfaceContainer
                                  .withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                      ),
                      child: Icon(
                        isCurrentlyUploading
                            ? Icons.cloud_upload_outlined
                            : Icons.audiotrack_outlined,
                        size: 18,
                        color: isCurrentlyUploading
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upload.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isCurrentlyUploading
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                  letterSpacing: -0.2,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isCurrentlyUploading) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Uploading now...',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                  ),
                            ),
                          ] else ...[
                            const SizedBox(height: 2),
                            Text(
                              'Queued for upload',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    if (isCurrentlyUploading)
                      Container(
                        padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: PRFSpacingTokens.lg,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                        ),
                        child: IconButton(
                          onPressed: progress.isRetrying
                              ? null
                              : () => _retrySpecificUpload(context, upload),
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: progress.isRetrying
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.4)
                                : Theme.of(context).colorScheme.primary,
                          ),
                          iconSize: 18,
                          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                          constraints: const BoxConstraints(),
                          tooltip: 'Retry upload',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.md,
                    vertical: PRFSpacingTokens.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: PRFSpacingTokens.xs),
                      Expanded(
                        child: Text(
                          'Failed on ${dateFormat.format(upload.failedAt)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                                fontSize: 12,
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
                          color: upload.retryCount > 3
                              ? Theme.of(
                                  context,
                                ).colorScheme.error.withValues(alpha: 0.1)
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${upload.retryCount} ${upload.retryCount == 1 ? 'retry' : 'retries'}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: upload.retryCount > 3
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _retrySpecificUpload(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) async {
    try {
      await getIt<FailedRecordingUploadService>().retrySpecificUpload(upload);
      PRFSnackbar.success(context, '${upload.name} uploaded successfully');
    } catch (e) {
      PRFSnackbar.error(context, 'Retry failed');
    }
  }
}
