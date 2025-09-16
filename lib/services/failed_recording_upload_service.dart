import 'dart:async';
import 'dart:io';

import 'package:app/models/local/prf_failed_recording_upload.dart';
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

  final _retryStreamController = StreamController<int>.broadcast();
  Stream<int> get retryStream => _retryStreamController.stream;

  final _pendingUploadsController =
      StreamController<List<PRFFailedRecordingUpload>>.broadcast();
  Stream<List<PRFFailedRecordingUpload>> get pendingUploadsStream =>
      _pendingUploadsController.stream;

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
      errorMessage: errorMessage,
    );

    await _isarService.prfDBInstance.writeTxn(() async {
      await _isarService.prfDBInstance.pRFFailedRecordingUploads.put(
        failedUpload,
      );
    });

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
      _retryStreamController.add(failedUploads.length);

      for (final failedUpload in failedUploads) {
        // Check if file still exists
        final file = File(failedUpload.path);
        if (!file.existsSync()) {
          // File doesn't exist anymore, remove from failed uploads
          await _removeFailedUpload(failedUpload.id);
          continue;
        }

        // Skip if we've retried too many times (max 5 retries)
        if (failedUpload.retryCount >= 5) {
          Logger().w('Max retry attempts reached for: ${failedUpload.name}');
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

      _notifyPendingUploadsChanged();
    } finally {
      _isRetrying = false;
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

    for (final failedUpload in failedUploads) {
      try {
        await retrySpecificUpload(failedUpload);
      } catch (e) {
        Logger().e('Failed to retry upload for ${failedUpload.name}: $e');
        // Continue with other uploads even if one fails
      }
    }
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
    _retryStreamController.close();
    _pendingUploadsController.close();
  }
}
