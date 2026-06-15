import 'dart:convert';

import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:crypto/crypto.dart';

/// Write-queue service for [PRFMediaDTO] objects pending upload.
///
/// The compound key `'<modelUlid>__<path-digest>'` keeps Hive keys bounded
/// while still uniquely identifying pending uploads for a model.
class MediaUploadHiveDbService extends BaseHiveDbService<PRFMediaDTO> {
  @override
  String get boxName => 'prf_media_uploads';

  @override
  String getKey(PRFMediaDTO entity) => _buildKey(entity.modelUlid, entity.path);

  @override
  PRFMediaDTO fromJson(Map<String, dynamic> json) => PRFMediaDTO.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMediaDTO entity) => entity.toJson();

  /// Removes a specific pending upload by its composite key.
  Future<void> deleteByKeys(String modelUlid, String path) =>
      deleteByKey(_buildKey(modelUlid, path));

  String _buildKey(String modelUlid, String path) {
    final pathDigest = sha256.convert(utf8.encode(path)).toString();
    return '${modelUlid}__$pathDigest';
  }
}
