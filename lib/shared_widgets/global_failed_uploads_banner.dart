import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GlobalFailedUploadsBanner extends StatefulWidget {
  const GlobalFailedUploadsBanner({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<GlobalFailedUploadsBanner> createState() =>
      _GlobalFailedUploadsBannerState();
}

class _GlobalFailedUploadsBannerState extends State<GlobalFailedUploadsBanner> {
  late FailedRecordingUploadService _failedUploadService;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _failedUploadService = GetIt.instance<FailedRecordingUploadService>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<PRFFailedRecordingUpload>>(
          stream: _failedUploadService.pendingUploadsStream,
          builder: (context, snapshot) {
            final pendingUploads = snapshot.data ?? [];

            if (pendingUploads.isEmpty) {
              return const SizedBox.shrink();
            }

            return _buildBanner(context, pendingUploads);
          },
        ),
        Expanded(child: widget.child),
      ],
    );
  }

  Widget _buildBanner(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              size: 20,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${pendingUploads.length} failed recording upload${pendingUploads.length == 1 ? '' : 's'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  Text(
                    'Tap to retry or view details',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isRetrying)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.error,
                  ),
                ),
              )
            else
              IconButton(
                onPressed: () => _retryAllUploads(context, pendingUploads),
                icon: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.error,
                ),
                iconSize: 20,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _showUploadDetails(context, pendingUploads),
              icon: Icon(
                Icons.list,
                color: theme.colorScheme.error,
              ),
              iconSize: 20,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _retryAllUploads(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      var successCount = 0;
      for (final upload in pendingUploads) {
        try {
          await _failedUploadService.retrySpecificUpload(upload);
          successCount++;
        } catch (e) {
          // Individual retry failed, continue with others
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              successCount > 0
                  ? '$successCount of ${pendingUploads.length} uploads successful'
                  : 'All retry attempts failed',
            ),
            backgroundColor: successCount > 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Retry error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  void _showUploadDetails(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _GlobalUploadDetailsSheet(
        pendingUploads: pendingUploads,
        failedUploadService: _failedUploadService,
      ),
    );
  }
}

class _GlobalUploadDetailsSheet extends StatefulWidget {
  const _GlobalUploadDetailsSheet({
    required this.pendingUploads,
    required this.failedUploadService,
  });

  final List<PRFFailedRecordingUpload> pendingUploads;
  final FailedRecordingUploadService failedUploadService;

  @override
  State<_GlobalUploadDetailsSheet> createState() =>
      _GlobalUploadDetailsSheetState();
}

class _GlobalUploadDetailsSheetState extends State<_GlobalUploadDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                    'Failed Recording Uploads',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _retryAllUploads(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<PRFFailedRecordingUpload>>(
                stream: widget.failedUploadService.pendingUploadsStream,
                builder: (context, snapshot) {
                  final currentUploads = snapshot.data ?? [];

                  if (currentUploads.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_done, size: 48, color: Colors.green),
                          SizedBox(height: 16),
                          Text('All uploads completed!'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: currentUploads.length,
                    itemBuilder: (context, index) {
                      final upload = currentUploads[index];
                      return _buildUploadItem(context, upload);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadItem(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) {
    final theme = Theme.of(context);

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
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upload.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Session: ${upload.modelUlid}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                  color: theme.colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Retry attempts: ${upload.retryCount}/5',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              upload.errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _retryAllUploads(BuildContext context) async {
    try {
      final currentUploads = await widget.failedUploadService
          .getPendingUploads();

      if (currentUploads.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      // Show progress indicator
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Retrying all uploads...'),
            ],
          ),
        ),
      );

      var successCount = 0;
      for (final upload in currentUploads) {
        try {
          await widget.failedUploadService.retrySpecificUpload(upload);
          successCount++;
        } catch (e) {
          // Continue with other uploads
        }
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              successCount > 0
                  ? '$successCount of ${currentUploads.length} uploads successful'
                  : 'All retry attempts failed',
            ),
            backgroundColor: successCount > 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Retry error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _retrySpecificUpload(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) async {
    try {
      await widget.failedUploadService.retrySpecificUpload(upload);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${upload.name} uploaded successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Retry failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${upload.name} removed')),
        );
      }
    }
  }
}
