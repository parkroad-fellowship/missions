import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Hive-backed storage for [PRFFailedRecordingUpload] objects.
///
/// Uses `path` as the unique key since a file path is inherently unique on
/// disk.  Data is stored as raw maps (no type adapters required).
class FailedRecordingUploadHiveDbService
    extends BaseHiveDbService<PRFFailedRecordingUpload> {
  @override
  String get boxName => 'prf_failed_recording_uploads';

  Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  List<PRFFailedRecordingUpload> getAll() {
    return _box.values
        .map(
          (v) => PRFFailedRecordingUpload.fromJson(v as Map<String, dynamic>),
        )
        .toList();
  }

  List<PRFFailedRecordingUpload> getByModelUlid(String modelUlid) {
    return getAll().where((u) => u.modelUlid == modelUlid).toList();
  }

  List<PRFFailedRecordingUpload> getByTarget({
    required String modelUlid,
    String? modelName,
  }) {
    return getAll().where((u) {
      if (u.modelUlid != modelUlid) return false;
      if (modelName != null && u.model.name != modelName) return false;
      return true;
    }).toList();
  }

  Future<void> deleteByPath(String path) async {
    await _box.delete(path);
  }

  @override
  String getKey(PRFFailedRecordingUpload entity) => entity.path;

  @override
  PRFFailedRecordingUpload fromJson(Map<String, dynamic> json) =>
      PRFFailedRecordingUpload.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFFailedRecordingUpload entity) =>
      entity.toJson();
}
