import 'dart:async';
import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/local/upload_retry_progress.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:logger/logger.dart';

class FailedRecordingUploadService {
  FailedRecordingUploadService({
    required MediaService mediaService,
    required HiveService hiveService,
  }) {
    _mediaService = mediaService;
    _hiveService = hiveService;
    _startConnectivityMonitoring();
    streamPendingUploads();
  }

  late MediaService _mediaService;
  late HiveService _hiveService;
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
    await _hiveService.failedRecordingUploads.deleteByPath(path);
  }

  Future<void> _putUpload(PRFFailedRecordingUpload upload) async {
    await _removeUploadByPath(upload.path);
    await _hiveService.failedRecordingUploads.persistEntity(upload);
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
    return _hiveService.failedRecordingUploads.getAll();
  }

  Future<List<PRFFailedRecordingUpload>> getPendingUploadsForSession(
    String missionSessionUlid,
  ) async {
    return _hiveService.failedRecordingUploads.getByModelUlid(
      missionSessionUlid,
    );
  }

  Future<List<PRFFailedRecordingUpload>> getPendingUploadsForTarget({
    required String modelUlid,
    PRFMediaModel? model,
  }) async {
    return _hiveService.failedRecordingUploads.getByTarget(
      modelUlid: modelUlid,
      modelName: model?.name,
    );
  }

  Future<void> retryAllUploads() async {
    await _checkAndRetryFailedUploads();
  }

  Future<void> _checkAndRetryFailedUploads() async {
    if (_isRetrying) return;

    try {
      _isRetrying = true;

      if (!await _hasInternetConnection()) {
        return;
      }

      final failedUploads = await getPendingUploads();
      if (failedUploads.isEmpty) return;

      Logger().d('Found ${failedUploads.length} failed uploads to retry');

      _retryProgressController.add(
        UploadRetryProgress(
          isRetrying: true,
          currentIndex: 0,
          totalCount: failedUploads.length,
        ),
      );

      for (var i = 0; i < failedUploads.length; i++) {
        final failedUpload = failedUploads[i];

        _retryProgressController.add(
          UploadRetryProgress(
            isRetrying: true,
            currentIndex: i + 1,
            totalCount: failedUploads.length,
            currentFileName: failedUpload.name,
          ),
        );

        final file = File(failedUpload.path);
        if (!file.existsSync()) {
          await _removeUploadByPath(failedUpload.path);
          continue;
        }

        try {
          final mediaDTO = PRFMediaDTO(
            model: failedUpload.model,
            modelUlid: failedUpload.modelUlid,
            path: failedUpload.path,
            name: failedUpload.name,
          );

          await _mediaService.uploadFile(
            imageDTO: mediaDTO,
            memberUlid: _hiveService.retrieveMember()!.ulid,
          );

          await _removeUploadByPath(failedUpload.path);
          Logger().d('Successfully retried upload for: ${failedUpload.name}');
        } catch (e) {
          await _updateFailedUploadRetryCount(failedUpload);
          Logger().e('Retry failed for ${failedUpload.name}: $e');
        }
      }

      _retryProgressController.add(UploadRetryProgress.complete);

      _notifyPendingUploadsChanged();
    } finally {
      _isRetrying = false;
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

  Future<void> _updateFailedUploadRetryCount(
    PRFFailedRecordingUpload failedUpload,
  ) async {
    await _hiveService.failedRecordingUploads.persistEntity(
      failedUpload.copyWith(retryCount: failedUpload.retryCount + 1),
    );
  }

  Future<void> retrySpecificUpload(
    PRFFailedRecordingUpload failedUpload,
  ) async {
    final file = File(failedUpload.path);
    if (!file.existsSync()) {
      await _removeUploadByPath(failedUpload.path);
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

      await _mediaService.uploadFile(
        imageDTO: mediaDTO,
        memberUlid: _hiveService.retrieveMember()!.ulid,
      );
      await _removeUploadByPath(failedUpload.path);
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

    _retryProgressController.add(
      UploadRetryProgress(
        isRetrying: true,
        currentIndex: 0,
        totalCount: failedUploads.length,
      ),
    );

    for (var i = 0; i < failedUploads.length; i++) {
      final failedUpload = failedUploads[i];

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
      }
    }

    _retryProgressController.add(UploadRetryProgress.complete);

    Timer(const Duration(seconds: 2), () {
      _retryProgressController.add(UploadRetryProgress.idle);
    });
  }

  Future<void> retryUploadsForTarget({
    required String modelUlid,
    PRFMediaModel? model,
  }) async {
    final failedUploads = await getPendingUploadsForTarget(
      modelUlid: modelUlid,
      model: model,
    );

    if (failedUploads.isEmpty) return;

    _retryProgressController.add(
      UploadRetryProgress(
        isRetrying: true,
        currentIndex: 0,
        totalCount: failedUploads.length,
      ),
    );

    for (var i = 0; i < failedUploads.length; i++) {
      final failedUpload = failedUploads[i];

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
      }
    }

    _retryProgressController.add(UploadRetryProgress.complete);

    Timer(const Duration(seconds: 2), () {
      _retryProgressController.add(UploadRetryProgress.idle);
    });
  }

  Future<void> removeAllFailedUploads() async {
    await _hiveService.failedRecordingUploads.clearAll();
    _notifyPendingUploadsChanged();
  }

  Future<void> removeAllFailedUploadsForSession(
    String missionSessionUlid,
  ) async {
    final uploadsToDelete = await getPendingUploadsForSession(
      missionSessionUlid,
    );
    for (final upload in uploadsToDelete) {
      await _removeUploadByPath(upload.path);
    }
    _notifyPendingUploadsChanged();
  }

  Future<void> removeFailedUpload(String path) async {
    await _removeUploadByPath(path);
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
