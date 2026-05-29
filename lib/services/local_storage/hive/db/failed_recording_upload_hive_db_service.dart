import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Hive-backed storage for [PRFFailedRecordingUpload] objects.
///
/// Uses `path` as the unique key since a file path is inherently unique on
/// disk.  Data is stored as raw maps (no type adapters required).
class FailedRecordingUploadHiveDbService {
  static const String boxName = 'prf_failed_recording_uploads';

  Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  List<PRFFailedRecordingUpload> getAll() {
    return _box.values
        .map((v) => PRFFailedRecordingUpload.fromMap(v as Map))
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

  Future<void> put(PRFFailedRecordingUpload upload) async {
    await _box.put(upload.path, upload.toMap());
  }

  Future<void> deleteByPath(String path) async {
    await _box.delete(path);
  }

  Future<void> update(PRFFailedRecordingUpload upload) async {
    await put(upload);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int get count => _box.length;
}
