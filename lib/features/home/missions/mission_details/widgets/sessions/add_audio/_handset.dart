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
import 'package:app/utils/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
                icon: const Icon(Icons.cloud_off),
                text: l10n.recordings,
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

              // Pending Uploads Tab
              _buildPendingUploadsTab(context, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingUploadsTab(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header with information
          Container(
            width: double.infinity,
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
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.recordings,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Recordings that failed to upload will appear here. '
                  "They will retry automatically when you're online.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pending uploads content
          Expanded(
            child: StreamBuilder<List<PRFFailedRecordingUpload>>(
              stream: GetIt.instance<FailedRecordingUploadService>()
                  .pendingUploadsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter pending uploads by this mission session ULID
                final allPendingUploads = snapshot.data!;
                final pendingUploads = allPendingUploads
                    .where((upload) => upload.modelUlid == widget.missionSessionUlid)
                    .toList();

                if (pendingUploads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_done,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noRecordings,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'All recordings for this session have been uploaded successfully',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Action buttons at the top
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _retryAllUploads(context, pendingUploads),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Retry All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _clearAllFailedUploads(context, pendingUploads),
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear All'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // List of pending uploads
                    Expanded(
                      child: ListView.builder(
                        itemCount: pendingUploads.length,
                        itemBuilder: (context, index) {
                          final upload = pendingUploads[index];
                          return _buildPendingUploadItem(context, upload, l10n);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveRecordingTab(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Pending uploads widget
        PendingUploadsWidget(
          failedUploadService: GetIt.instance<FailedRecordingUploadService>(),
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

  Widget _buildPendingUploadItem(
    BuildContext context,
    PRFFailedRecordingUpload upload,
    AppLocalizations l10n,
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

  Future<void> _retryAllUploads(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) async {
    final failedUploadService = GetIt.instance<FailedRecordingUploadService>();

    try {
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

      await failedUploadService.retryAllUploadsForSession(widget.missionSessionUlid);

      Navigator.of(context).pop(); // Close progress dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Successfully retried all uploads for this session'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close progress dialog if still open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some uploads failed to retry. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _clearAllFailedUploads(
    BuildContext context,
    List<PRFFailedRecordingUpload> pendingUploads,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Uploads'),
        content: Text(
          'Remove all ${pendingUploads.length} pending uploads for this session? This action cannot be undone.',
        ),
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
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final failedUploadService =
          GetIt.instance<FailedRecordingUploadService>();

      await failedUploadService.removeAllFailedUploadsForSession(widget.missionSessionUlid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cleared all pending uploads for this session'),
        ),
      );
    }
  }

  Future<void> _retrySpecificUpload(
    BuildContext context,
    PRFFailedRecordingUpload upload,
  ) async {
    final failedUploadService = GetIt.instance<FailedRecordingUploadService>();

    try {
      await failedUploadService.retrySpecificUpload(upload);
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
      final failedUploadService =
          GetIt.instance<FailedRecordingUploadService>();
      await failedUploadService.removeFailedUpload(upload.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${upload.name} removed')),
      );
    }
  }
}
