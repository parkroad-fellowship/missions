class UploadRetryProgress {
  const UploadRetryProgress({
    required this.isRetrying,
    required this.currentIndex,
    required this.totalCount,
    this.currentFileName,
    this.isComplete = false,
  });

  final bool isRetrying;
  final int currentIndex;
  final int totalCount;
  final String? currentFileName;
  final bool isComplete;

  static const UploadRetryProgress idle = UploadRetryProgress(
    isRetrying: false,
    currentIndex: 0,
    totalCount: 0,
  );

  static const UploadRetryProgress complete = UploadRetryProgress(
    isRetrying: false,
    currentIndex: 0,
    totalCount: 0,
    isComplete: true,
  );

  double get progress => totalCount > 0 ? currentIndex / totalCount : 0.0;

  String get progressText => totalCount > 0 
    ? 'Uploading $currentIndex of $totalCount'
    : 'Preparing uploads...';

  UploadRetryProgress copyWith({
    bool? isRetrying,
    int? currentIndex,
    int? totalCount,
    String? currentFileName,
    bool? isComplete,
  }) {
    return UploadRetryProgress(
      isRetrying: isRetrying ?? this.isRetrying,
      currentIndex: currentIndex ?? this.currentIndex,
      totalCount: totalCount ?? this.totalCount,
      currentFileName: currentFileName ?? this.currentFileName,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
