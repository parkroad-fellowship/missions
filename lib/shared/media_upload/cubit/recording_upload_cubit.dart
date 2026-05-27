import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/media/failed_recording_upload_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'recording_upload_cubit.freezed.dart';
part 'recording_upload_state.dart';

class RecordingUploadCubit extends Cubit<RecordingUploadState> {
  RecordingUploadCubit({
    required MediaService mediaService,
    required FailedRecordingUploadService failedUploadService,
    required HiveService hiveService,
  }) : super(const RecordingUploadState.initial()) {
    _mediaService = mediaService;
    _failedUploadService = failedUploadService;
    _hiveService = hiveService;
  }

  late MediaService _mediaService;
  late FailedRecordingUploadService _failedUploadService;
  late HiveService _hiveService;

  Future<void> uploadRecording(PRFMediaDTO mediaDTO) async {
    emit(const RecordingUploadState.loading());
    try {
      // Track locally first so the UI can reflect a queued item immediately.
      await _failedUploadService.storePendingUpload(mediaDTO);

      Logger().d('Uploading recording: ${mediaDTO.name}');
      final result = await _mediaService.uploadFile(
        imageDTO: mediaDTO,
        memberUlid: _hiveService.retrieveMember()!.ulid,
      );
      if (result != null) {
        Logger().d('Recording upload successful: ${mediaDTO.name}');
        await _failedUploadService.removeFailedUploadByPath(mediaDTO.path);
        emit(RecordingUploadState.loaded(mediaDTO));
      } else {
        Logger().w('Recording upload returned null: ${mediaDTO.name}');
        await _failedUploadService.storeFailedUpload(
          mediaDTO,
          'Upload failed - no result returned',
        );
        emit(
          const RecordingUploadState.error(
            'Upload failed - no result returned',
          ),
        );
      }
    } on Failure catch (e) {
      Logger().e(
        'Recording upload failed with Failure: ${mediaDTO.name} - ${e.message}',
      );
      // Store failed upload for retry later
      await _failedUploadService.storeFailedUpload(mediaDTO, e.message);
      emit(RecordingUploadState.error(e.message));
    } catch (e) {
      Logger().e(
        'Recording upload failed with Exception: ${mediaDTO.name} - $e',
      );
      // Store failed upload for retry later
      await _failedUploadService.storeFailedUpload(mediaDTO, e.toString());
      emit(RecordingUploadState.error(e.toString()));
    }
  }

  Future<void> uploadMultipleRecordings(List<PRFMediaDTO> mediaDTOs) async {
    emit(const RecordingUploadState.loading());
    try {
      final uploadedFiles = <PRFMediaDTO>[];

      for (final mediaDTO in mediaDTOs) {
        Logger().d('Uploading recording: ${mediaDTO.name}');
        try {
          await _failedUploadService.storePendingUpload(mediaDTO);
          await _mediaService.uploadFile(
            imageDTO: mediaDTO,
            memberUlid: _hiveService.retrieveMember()!.ulid,
          );
          await _failedUploadService.removeFailedUploadByPath(mediaDTO.path);
          uploadedFiles.add(mediaDTO);
        } on Failure catch (e) {
          // Store failed upload for retry later
          await _failedUploadService.storeFailedUpload(mediaDTO, e.message);
          Logger().e('Failed to upload ${mediaDTO.name}: ${e.message}');
        } catch (e) {
          // Store failed upload for retry later
          await _failedUploadService.storeFailedUpload(mediaDTO, e.toString());
          Logger().e('Failed to upload ${mediaDTO.name}: $e');
        }
      }

      if (uploadedFiles.isNotEmpty) {
        emit(RecordingUploadState.multipleLoaded(uploadedFiles));
      } else {
        emit(
          const RecordingUploadState.error(
            'All uploads failed. '
            'They will be retried when you come back online.',
          ),
        );
      }
    } catch (e) {
      emit(RecordingUploadState.error(e.toString()));
    }
  }

  void reset() {
    emit(const RecordingUploadState.initial());
  }
}
