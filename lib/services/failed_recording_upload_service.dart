import 'dart:async';
import 'dart:io';

import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/local/upload_retry_progress.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

class FailedRecordingUploadService {
  FailedRecordingUploadService({
    required IsarService isarService,
    required MediaService mediaService,
  }) {
    _isarService = isarService;
    _mediaService = mediaService;
    _startConnectivityMonitoring();
  }

  late IsarService _isarService;
  late MediaService _mediaService;
  Timer? _connectivityTimer;
  bool _isRetrying = false;

  final _retryProgressController =
      StreamController<UploadRetryProgress>.broadcast();
  Stream<UploadRetryProgress> get retryProgressStream =>
      _retryProgressController.stream;

  final _pendingUploadsController =
      StreamController<List<PRFFailedRecordingUpload>>.broadcast();
  Stream<List<PRFFailedRecordingUpload>> get pendingUploadsStream =>
      _pendingUploadsController.stream;

  Future<void> _removeUploadByPath(String path) async {
    final existing = await _isarService.prfDBInstance.pRFFailedRecordingUploads
        .filter()
        .pathEqualTo(path)
        .findAll();

    if (existing.isEmpty) return;

    await _isarService.prfDBInstance.writeTxn(() async {
      for (final upload in existing) {
        await _isarService.prfDBInstance.pRFFailedRecordingUploads.delete(
          upload.id,
        );
      }
    });
  }

  Future<void> _putUpload(PRFFailedRecordingUpload upload) async {
    // Ensure we do not accumulate duplicates for the same file path.
    await _removeUploadByPath(upload.path);

    await _isarService.prfDBInstance.writeTxn(() async {
      await _isarService.prfDBInstance.pRFFailedRecordingUploads.put(upload);
    });
  }

  Future<void> storePendingUpload(PRFMediaDTO mediaDTO) async {
    final pendingUpload = PRFFailedRecordingUpload(
      model: mediaDTO.model,
      modelUlid: mediaDTO.modelUlid,
      path: mediaDTO.path,
      name: mediaDTO.name,
      failedAt: DateTime.now(),
    );

    await _putUpload(pendingUpload);
    _notifyPendingUploadsChanged();
  }

  void _startConnectivityMonitoring() {
    _connectivityTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkAndRetryFailedUploads();
    });
  }

  Future<void> storeFailedUpload(
    PRFMediaDTO mediaDTO,
    String errorMessage,
  ) async {
    Logger().w(
      '🔄 Storing failed upload: ${mediaDTO.name} - Error: $errorMessage',
    );

    final failedUpload = PRFFailedRecordingUpload(
      model: mediaDTO.model,
      modelUlid: mediaDTO.modelUlid,
      path: mediaDTO.path,
      name: mediaDTO.name,
      failedAt: DateTime.now(),
    );

    await _putUpload(failedUpload);

    Logger().d('✅ Stored failed upload for: ${mediaDTO.name}');
    _notifyPendingUploadsChanged();
  }

  Future<List<PRFFailedRecordingUpload>> getPendingUploads() async {
    return _isarService.prfDBInstance.pRFFailedRecordingUploads
        .where()
        .findAll();
  }

  Future<List<PRFFailedRecordingUpload>> getPendingUploadsForSession(
    String missionSessionUlid,
  ) async {
    return _isarService.prfDBInstance.pRFFailedRecordingUploads
        .filter()
        .modelUlidEqualTo(missionSessionUlid)
        .findAll();
  }

  Future<void> _checkAndRetryFailedUploads() async {
    if (_isRetrying) return;

    try {
      _isRetrying = true;

      // Check if we have internet connectivity
      if (!await _hasInternetConnection()) {
        return;
      }

      final failedUploads = await getPendingUploads();
      if (failedUploads.isEmpty) return;

      Logger().d('Found ${failedUploads.length} failed uploads to retry');

      // Emit initial progress
      _retryProgressController.add(
        UploadRetryProgress(
          isRetrying: true,
          currentIndex: 0,
          totalCount: failedUploads.length,
        ),
      );

      for (var i = 0; i < failedUploads.length; i++) {
        final failedUpload = failedUploads[i];

        // Update progress with current file
        _retryProgressController.add(
          UploadRetryProgress(
            isRetrying: true,
            currentIndex: i + 1,
            totalCount: failedUploads.length,
            currentFileName: failedUpload.name,
          ),
        );

        // Check if file still exists
        final file = File(failedUpload.path);
        if (!file.existsSync()) {
          // File doesn't exist anymore, remove from failed uploads
          await _removeFailedUpload(failedUpload.id);
          continue;
        }

        try {
          final mediaDTO = PRFMediaDTO(
            model: failedUpload.model,
            modelUlid: failedUpload.modelUlid,
            path: failedUpload.path,
            name: failedUpload.name,
          );

          await _mediaService.uploadFile(imageDTO: mediaDTO);

          // Upload successful, remove from failed uploads
          await _removeFailedUpload(failedUpload.id);
          Logger().d('Successfully retried upload for: ${failedUpload.name}');
        } catch (e) {
          // Update retry count
          await _updateFailedUploadRetryCount(failedUpload);
          Logger().e('Retry failed for ${failedUpload.name}: $e');
        }
      }

      // Emit completion
      _retryProgressController.add(UploadRetryProgress.complete);

      _notifyPendingUploadsChanged();
    } finally {
      _isRetrying = false;
      // Reset to idle after a short delay
      Timer(const Duration(seconds: 2), () {
        _retryProgressController.add(UploadRetryProgress.idle);
      });
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _removeFailedUpload(Id id) async {
    await _isarService.prfDBInstance.writeTxn(() async {
      await _isarService.prfDBInstance.pRFFailedRecordingUploads.delete(id);
    });
  }

  Future<void> _updateFailedUploadRetryCount(
    PRFFailedRecordingUpload failedUpload,
  ) async {
    final updatedUpload = failedUpload.copyWith(
      id: failedUpload.id,
      retryCount: failedUpload.retryCount + 1,
    );

    await _isarService.prfDBInstance.writeTxn(() async {
      await _isarService.prfDBInstance.pRFFailedRecordingUploads.put(
        updatedUpload,
      );
    });
  }

  Future<void> retrySpecificUpload(
    PRFFailedRecordingUpload failedUpload,
  ) async {
    final file = File(failedUpload.path);
    if (!file.existsSync()) {
      await _removeFailedUpload(failedUpload.id);
      _notifyPendingUploadsChanged();
      throw Exception('File no longer exists');
    }

    try {
      final mediaDTO = PRFMediaDTO(
        model: failedUpload.model,
        modelUlid: failedUpload.modelUlid,
        path: failedUpload.path,
        name: failedUpload.name,
      );

      await _mediaService.uploadFile(imageDTO: mediaDTO);
      await _removeFailedUpload(failedUpload.id);
      _notifyPendingUploadsChanged();
    } catch (e) {
      await _updateFailedUploadRetryCount(failedUpload);
      _notifyPendingUploadsChanged();
      rethrow;
    }
  }

  Future<void> retryAllUploadsForSession(String missionSessionUlid) async {
    final failedUploads = await getPendingUploadsForSession(missionSessionUlid);

    if (failedUploads.isEmpty) return;

    // Emit initial progress
    _retryProgressController.add(
      UploadRetryProgress(
        isRetrying: true,
        currentIndex: 0,
        totalCount: failedUploads.length,
      ),
    );

    for (var i = 0; i < failedUploads.length; i++) {
      final failedUpload = failedUploads[i];

      // Update progress with current file
      _retryProgressController.add(
        UploadRetryProgress(
          isRetrying: true,
          currentIndex: i + 1,
          totalCount: failedUploads.length,
          currentFileName: failedUpload.name,
        ),
      );

      try {
        await retrySpecificUpload(failedUpload);
      } catch (e) {
        Logger().e('Failed to retry upload for ${failedUpload.name}: $e');
        // Continue with other uploads even if one fails
      }
    }

    // Emit completion
    _retryProgressController.add(UploadRetryProgress.complete);

    // Reset to idle after a short delay
    Timer(const Duration(seconds: 2), () {
      _retryProgressController.add(UploadRetryProgress.idle);
    });
  }

  Future<void> removeAllFailedUploads() async {
    await _isarService.prfDBInstance.writeTxn(() async {
      await _isarService.prfDBInstance.pRFFailedRecordingUploads.clear();
    });
    _notifyPendingUploadsChanged();
  }

  Future<void> removeAllFailedUploadsForSession(
    String missionSessionUlid,
  ) async {
    final uploadsToDelete = await getPendingUploadsForSession(
      missionSessionUlid,
    );

    await _isarService.prfDBInstance.writeTxn(() async {
      for (final upload in uploadsToDelete) {
        await _isarService.prfDBInstance.pRFFailedRecordingUploads.delete(
          upload.id,
        );
      }
    });
    _notifyPendingUploadsChanged();
  }

  Future<void> removeFailedUpload(Id id) async {
    await _removeFailedUpload(id);
    _notifyPendingUploadsChanged();
  }

  Future<void> removeFailedUploadByPath(String path) async {
    await _removeUploadByPath(path);
    _notifyPendingUploadsChanged();
  }

  void streamPendingUploads() {
    getPendingUploads().then(_pendingUploadsController.add);
  }

  void _notifyPendingUploadsChanged() {
    getPendingUploads().then((uploads) {
      Logger().d(
        '📢 Notifying pending uploads changed: ${uploads.length} uploads',
      );
      _pendingUploadsController.add(uploads);
    });
  }

  void dispose() {
    _connectivityTimer?.cancel();
    _retryProgressController.close();
    _pendingUploadsController.close();
  }
}
