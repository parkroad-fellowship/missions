import 'package:app/enums/prf_media_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Local-only model for recording uploads that failed and are queued for retry.

part 'prf_failed_recording_upload.freezed.dart';
part 'prf_failed_recording_upload.g.dart';

@freezed
abstract class PRFFailedRecordingUpload with _$PRFFailedRecordingUpload {
  factory PRFFailedRecordingUpload({
    required PRFMediaModel model,
    required String modelUlid,
    required String path,
    required String name,
    required DateTime failedAt,
    @Default(0) int retryCount,
  }) = _PRFFailedRecordingUpload;

  factory PRFFailedRecordingUpload.fromJson(Map<String, dynamic> json) =>
      _$PRFFailedRecordingUploadFromJson(json);
}
