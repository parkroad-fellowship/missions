import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingUploadsWidget extends StatefulWidget {
  const PendingUploadsWidget({
    required this.failedUploadService,
    required this.missionSessionUlid,
    super.key,
  });

  final FailedRecordingUploadService failedUploadService;
  final String missionSessionUlid;

  @override
  State<PendingUploadsWidget> createState() => _PendingUploadsWidgetState();
}

class _PendingUploadsWidgetState extends State<PendingUploadsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PRFFailedRecordingUpload>>(
      stream: widget.failedUploadService.pendingUploadsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Don't show anything while loading
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        // Filter pending uploads by this mission session ULID
        final allPendingUploads = snapshot.data!;
        final pendingUploads = allPendingUploads
            .where((upload) => upload.modelUlid == widget.missionSessionUlid)
            .toList();

        if (pendingUploads.isEmpty) {
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
        }

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
                        _showPendingUploadsDetails(context, pendingUploads),
                    child: Text(
                      '${pendingUploads.length} ${pendingUploads.length == 1 ? 'recording' : 'recordings'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Recordings will retry automatically when you come online',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _retryAllUploads(context),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry Now'),
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
                    onPressed: () =>
                        _showPendingUploadsDetails(context, pendingUploads),
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
  }

  Future<void> _retryAllUploads(BuildContext context) async {
    try {
      // Get current pending uploads for this session
      final pendingUploads = await widget.failedUploadService
          .getPendingUploadsForSession(widget.missionSessionUlid);

      if (pendingUploads.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pending uploads for this session')),
        );
        return;
      }

      // Show progress indicator
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Retrying uploads...'),
            ],
          ),
        ),
      );

      await widget.failedUploadService.retryAllUploadsForSession(
        widget.missionSessionUlid,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Successfully retried all uploads for this session',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Some uploads failed to retry. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showPendingUploadsDetails(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
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
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _retryAllUploads(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
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
    );
  }

  Widget _buildUploadItem(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.audiotrack,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    upload.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => _retrySpecificUpload(context, upload),
                  icon: const Icon(Icons.refresh),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _removeUpload(context, upload),
                  icon: const Icon(Icons.delete),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Failed at: ${dateFormat.format(upload.failedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              'Retry attempts: ${upload.retryCount}/5',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              upload.errorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _retrySpecificUpload(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) async {
    try {
      await widget.failedUploadService.retrySpecificUpload(upload);
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

  Future<void> _removeUpload(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Upload'),
        content: Text('Remove "${upload.name}" from pending uploads?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await widget.failedUploadService.removeFailedUpload(upload.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${upload.name} removed')),
      );
    }
  }
}
