class UploadRetryProgress {
  const UploadRetryProgress({
    required this.isRetrying,
    required this.currentIndex,
    required this.totalCount,
    this.currentFileName,
  });

  final bool isRetrying;
  final int currentIndex;
  final int totalCount;
  final String? currentFileName;

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
