import 'package:app/di/_index.dart';
import 'package:app/models/local/media/prf_failed_recording_upload.dart';
import 'package:app/models/local/media/upload_retry_progress.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/utils/router/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class GlobalRecordingUploadsBar extends StatelessWidget {
  const GlobalRecordingUploadsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PRFFailedRecordingUpload>>(
      stream: getIt<FailedRecordingUploadService>().pendingUploadsStream,
      builder: (context, pendingSnapshot) {
        final pending =
            pendingSnapshot.data ?? const <PRFFailedRecordingUpload>[];

        return StreamBuilder<UploadRetryProgress>(
          stream: getIt<FailedRecordingUploadService>().retryProgressStream,
          builder: (context, progressSnapshot) {
            final progress = progressSnapshot.data ?? UploadRetryProgress.idle;

            final shouldShow = pending.isNotEmpty || progress.isRetrying;
            if (!shouldShow) return const SizedBox.shrink();

            return Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.all(PRFSpacingTokens.lg),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.lg,
                      vertical: PRFSpacingTokens.md,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: PRFColors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              progress.isRetrying
                                  ? Icons.cloud_upload_outlined
                                  : Icons.cloud_queue_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: PRFSpacingTokens.sm),
                            Expanded(
                              child: Text(
                                progress.isRetrying
                                    ? progress.progressText
                                    : '${pending.length} queued upload${pending.length == 1 ? '' : 's'}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: PRFSpacingTokens.sm),
                            SizedBox(
                              width: 88,
                              child: PRFSecondaryButton(
                                onPressed: () => _showDetails(context),
                                title: 'View',
                                disabled: false,
                              ),
                            ),
                          ],
                        ),
                        if (progress.isRetrying) ...[
                          const SizedBox(height: PRFSpacingTokens.sm),
                          PRFLinearProgressIndicator(
                            value: progress.progress,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          if (progress.currentFileName != null) ...[
                            const SizedBox(height: PRFSpacingTokens.xs),
                            Text(
                              progress.currentFileName!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ] else ...[
                          const SizedBox(height: PRFSpacingTokens.sm),
                          Row(
                            children: [
                              Expanded(
                                child: PRFPrimaryButton(
                                  onPressed: () {
                                    getIt<FailedRecordingUploadService>()
                                        .retryAllUploads();
                                  },
                                  title: 'Retry now',
                                  disabled: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDetails(BuildContext context) {
    final navigatorContext =
        getIt<PRFSuperAppRouter>().navigatorKey.currentContext;
    final sheetContext = navigatorContext ?? context;
    PRFBottomSheet.show<void>(
      sheetContext,
      title: 'Pending uploads',
      child: const _PendingUploadsDetails(),
    );
  }
}

class _PendingUploadsDetails extends StatelessWidget {
  const _PendingUploadsDetails();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: StreamBuilder<List<PRFFailedRecordingUpload>>(
        stream: getIt<FailedRecordingUploadService>().pendingUploadsStream,
        builder: (context, snapshot) {
          final uploads = snapshot.data ?? const <PRFFailedRecordingUpload>[];

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${uploads.length} queued',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  StreamBuilder<UploadRetryProgress>(
                    stream: getIt<FailedRecordingUploadService>()
                        .retryProgressStream,
                    builder: (context, progressSnapshot) {
                      final progress =
                          progressSnapshot.data ?? UploadRetryProgress.idle;
                      return SizedBox(
                        width: 120,
                        child: PRFPrimaryButton(
                          onPressed: () {
                            getIt<FailedRecordingUploadService>()
                                .retryAllUploads();
                          },
                          title: progress.isRetrying
                              ? 'Uploading...'
                              : 'Retry all',
                          disabled: progress.isRetrying,
                          isLoading: progress.isRetrying,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Expanded(
                child: uploads.isEmpty
                    ? Center(
                        child: Text(
                          'No pending uploads',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemCount: uploads.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: PRFSpacingTokens.md),
                        itemBuilder: (context, index) => _UploadTile(
                          upload: uploads[index],
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

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.upload});

  final PRFFailedRecordingUpload upload;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
            ),
            child: const Icon(
              Icons.audiotrack_outlined,
              size: 18,
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upload.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: PRFSpacingTokens.xs),
                Text(
                  '${upload.model.collection} • ${dateFormat.format(upload.failedAt)} • retries ${upload.retryCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: PRFSpacingTokens.sm),
          IconButton(
            onPressed: () => getIt<FailedRecordingUploadService>()
                .retrySpecificUpload(upload)
                .catchError((_) {}),
            icon: const Icon(Icons.refresh),
            tooltip: 'Retry',
          ),
          IconButton(
            onPressed: () => getIt<FailedRecordingUploadService>()
                .removeFailedUpload(upload.id),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
