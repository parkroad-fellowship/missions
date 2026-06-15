import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_retry_progress.freezed.dart';
part 'upload_retry_progress.g.dart';

@freezed
abstract class UploadRetryProgress with _$UploadRetryProgress {
  const factory UploadRetryProgress({
    required bool isRetrying,
    required int currentIndex,
    required int totalCount,
    String? currentFileName,
  }) = _UploadRetryProgress;

  const UploadRetryProgress._();

  factory UploadRetryProgress.fromJson(Map<String, dynamic> json) =>
      _$UploadRetryProgressFromJson(json);

  bool get isComplete => !isRetrying && totalCount > 0;

  double get progress => totalCount == 0 ? 0.0 : currentIndex / totalCount;

  String get progressText =>
      totalCount == 0 ? '' : '$currentIndex / $totalCount';

  static const idle = UploadRetryProgress(
    isRetrying: false,
    currentIndex: 0,
    totalCount: 0,
  );

  static const complete = UploadRetryProgress(
    isRetrying: false,
    currentIndex: 0,
    totalCount: 0,
  );
}
