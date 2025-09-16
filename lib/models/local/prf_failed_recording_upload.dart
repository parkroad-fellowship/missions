import 'package:app/enums/prf_media_model.dart';
import 'package:isar_community/isar.dart';

part 'prf_failed_recording_upload.g.dart';

@collection
class PRFFailedRecordingUpload {
  PRFFailedRecordingUpload({
    required this.model,
    required this.modelUlid,
    required this.path,
    required this.name,
    required this.failedAt,
    this.retryCount = 0,
  });

  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.ordinal32)
  final PRFMediaModel model;

  @Index()
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
    String? errorMessage,
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
}
