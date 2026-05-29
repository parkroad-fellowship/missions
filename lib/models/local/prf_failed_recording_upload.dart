import 'package:app/enums/prf_media_model.dart';

/// Local-only model for recording uploads that failed and are queued for retry.
class PRFFailedRecordingUpload {
  PRFFailedRecordingUpload({
    required this.model,
    required this.modelUlid,
    required this.path,
    required this.name,
    required this.failedAt,
    this.retryCount = 0,
  });

  factory PRFFailedRecordingUpload.fromMap(Map<dynamic, dynamic> map) {
    return PRFFailedRecordingUpload(
      model: PRFMediaModel.values.byName(map['model'] as String),
      modelUlid: map['modelUlid'] as String,
      path: map['path'] as String,
      name: map['name'] as String,
      failedAt: DateTime.parse(map['failedAt'] as String),
      retryCount: (map['retryCount'] as int?) ?? 0,
    );
  }

  final PRFMediaModel model;
  final String modelUlid;
  final String path;
  final String name;
  final DateTime failedAt;
  final int retryCount;

  PRFFailedRecordingUpload copyWith({
    PRFMediaModel? model,
    String? modelUlid,
    String? path,
    String? name,
    DateTime? failedAt,
    int? retryCount,
  }) {
    return PRFFailedRecordingUpload(
      model: model ?? this.model,
      modelUlid: modelUlid ?? this.modelUlid,
      path: path ?? this.path,
      name: name ?? this.name,
      failedAt: failedAt ?? this.failedAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'model': model.name,
    'modelUlid': modelUlid,
    'path': path,
    'name': name,
    'failedAt': failedAt.toIso8601String(),
    'retryCount': retryCount,
  };
}
