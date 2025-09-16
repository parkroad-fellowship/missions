import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/local/upload_retry_progress.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/utils/_index.dart';
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

        if (allPendingUploads.isEmpty) {
          return StreamBuilder<UploadRetryProgress>(
            stream: getIt<FailedRecordingUploadService>().retryProgressStream,
            builder: (context, progressSnapshot) {
              final progress = progressSnapshot.data ?? UploadRetryProgress.idle;
              
              if (progress.isComplete) {
                return _buildSuccessMessage(context);
              }
              
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(width: 8),
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
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pending Uploads',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            _showPendingUploadsDetails(context, allPendingUploads),
                        child: Text(
                          '${allPendingUploads.length} '
                          '${allPendingUploads.length == 1 ? 'recording' : 'record'
                                    'ings'}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress indicator
                  if (progress.isRetrying) ...[
                    _buildProgressIndicator(context, progress),
                    const SizedBox(height: 12),
                  ] else ...[
                    Text(
                      'Recordings will retry automatically when you come online',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: progress.isRetrying ? null : () => _retryAllUploads(context),
                          icon: progress.isRetrying 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 16),
                          label: Text(progress.isRetrying ? 'Uploading...' : 'Retry Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: progress.isRetrying 
                            ? null 
                            : () => _showPendingUploadsDetails(context, allPendingUploads),
                        icon: const Icon(Icons.list, size: 16),
                        label: const Text('View All'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pending uploads for this session')),
        );
        return;
      }

      await getIt<FailedRecordingUploadService>().retryAllUploadsForSession(
        widget.missionSessionUlid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Some uploads failed to retry. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildProgressIndicator(BuildContext context, UploadRetryProgress progress) {
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
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        if (progress.currentFileName != null) ...[
          const SizedBox(height: 4),
          Text(
            'Uploading: ${progress.currentFileName}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 8),
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
                padding: const EdgeInsets.all(16),
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
                          stream: getIt<FailedRecordingUploadService>().retryProgressStream,
                          builder: (context, progressSnapshot) {
                            final progress = progressSnapshot.data ?? UploadRetryProgress.idle;
                            
                            return TextButton.icon(
                              onPressed: progress.isRetrying 
                                  ? null 
                                  : () {
                                      Navigator.of(context).pop();
                                      _retryAllUploads(context);
                                    },
                              icon: progress.isRetrying
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.refresh),
                              label: Text(progress.isRetrying ? 'Uploading...' : 'Retry All'),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    // Progress indicator in modal
                    StreamBuilder<UploadRetryProgress>(
                      stream: getIt<FailedRecordingUploadService>().retryProgressStream,
                      builder: (context, progressSnapshot) {
                        final progress = progressSnapshot.data ?? UploadRetryProgress.idle;
                        
                        if (progress.isRetrying) {
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              _buildProgressIndicator(context, progress),
                              const SizedBox(height: 16),
                            ],
                          );
                        }
                        return const SizedBox(height: 16);
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
        final isCurrentlyUploading = progress.isRetrying && 
            progress.currentFileName == upload.name;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isCurrentlyUploading ? 2 : 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCurrentlyUploading ? Icons.cloud_upload : Icons.audiotrack,
                      size: 20,
                      color: isCurrentlyUploading 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        upload.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isCurrentlyUploading 
                              ? FontWeight.w600 
                              : FontWeight.w500,
                          color: isCurrentlyUploading 
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentlyUploading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        onPressed: progress.isRetrying 
                            ? null 
                            : () => _retrySpecificUpload(context, upload),
                        icon: const Icon(Icons.refresh),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Failed on: ${dateFormat.format(upload.failedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  'Retry attempts: ${upload.retryCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (isCurrentlyUploading) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Uploading now...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${upload.name} uploaded successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Retry failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
