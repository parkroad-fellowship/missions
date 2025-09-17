part of 'audio_recording_cubit.dart';

@freezed
class AudioRecordingState with _$AudioRecordingState {
  const factory AudioRecordingState.initial() = _Initial;
  const factory AudioRecordingState.ready() = _Ready;
  const factory AudioRecordingState.recording({
    required Duration duration,
  }) = _Recording;
  const factory AudioRecordingState.paused({
    required Duration duration,
  }) = _Paused;
  const factory AudioRecordingState.completed({
    required String filePath,
    required Duration duration,
  }) = _Completed;
  const factory AudioRecordingState.error({
    required String message,
  }) = _Error;
}
