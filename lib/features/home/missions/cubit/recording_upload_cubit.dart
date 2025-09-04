import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'recording_upload_state.dart';
part 'recording_upload_cubit.freezed.dart';

class RecordingUploadCubit extends Cubit<RecordingUploadState> {
  RecordingUploadCubit({
    required MediaService mediaService,
  }) : super(const RecordingUploadState.initial()) {
    _mediaService = mediaService;
  }

  late MediaService _mediaService;

  Future<void> uploadRecording(PRFMediaDTO mediaDTO) async {
    emit(const RecordingUploadState.loading());
    try {
      Logger().d('Uploading recording: ${mediaDTO.name}');
      await _mediaService.uploadFile(imageDTO: mediaDTO);
      emit(RecordingUploadState.loaded(mediaDTO));
    } on Failure catch (e) {
      emit(RecordingUploadState.error(e.message));
    } catch (e) {
      emit(RecordingUploadState.error(e.toString()));
    }
  }

  Future<void> uploadMultipleRecordings(List<PRFMediaDTO> mediaDTOs) async {
    emit(const RecordingUploadState.loading());
    try {
      final uploadedFiles = <PRFMediaDTO>[];

      for (final mediaDTO in mediaDTOs) {
        Logger().d('Uploading recording: ${mediaDTO.name}');
        await _mediaService.uploadFile(imageDTO: mediaDTO);
        uploadedFiles.add(mediaDTO);
      }

      emit(RecordingUploadState.multipleLoaded(uploadedFiles));
    } on Failure catch (e) {
      emit(RecordingUploadState.error(e.message));
    } catch (e) {
      emit(RecordingUploadState.error(e.toString()));
    }
  }

  void reset() {
    emit(const RecordingUploadState.initial());
  }
}
