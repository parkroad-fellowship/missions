import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

/// Write-queue service for [PRFMediaDTO] objects pending upload.
///
/// The compound key `'<modelUlid>__<path>'` uniquely identifies each pending
/// upload even when multiple files belong to the same model.
class MediaUploadHiveDbService extends BaseHiveDbService<PRFMediaDTO> {
  @override
  String get boxName => 'prf_media_uploads';

  @override
  String getKey(PRFMediaDTO entity) => '${entity.modelUlid}__${entity.path}';

  @override
  PRFMediaDTO fromJson(Map<String, dynamic> json) => PRFMediaDTO.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMediaDTO entity) => entity.toJson();

  /// Removes a specific pending upload by its composite key.
  Future<void> deleteByKeys(String modelUlid, String path) =>
      deleteByKey('${modelUlid}__$path');
}
