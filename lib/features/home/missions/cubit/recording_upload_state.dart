part of 'recording_upload_cubit.dart';

@freezed
class RecordingUploadState with _$RecordingUploadState {
  const factory RecordingUploadState.initial() = _Initial;
  const factory RecordingUploadState.loading() = _Loading;
  const factory RecordingUploadState.loaded(PRFMediaDTO uploadedFile) = _Loaded;
  const factory RecordingUploadState.multipleLoaded(
    List<PRFMediaDTO> uploadedFiles,
  ) = _MultipleLoaded;
  const factory RecordingUploadState.error(String message) = _Error;
}
