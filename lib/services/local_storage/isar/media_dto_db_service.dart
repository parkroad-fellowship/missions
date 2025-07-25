import 'package:app/models/local/prf_media_upload.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/local_storage/isar/_base_min_local_db_service.dart';
import 'package:app/utils/misc.dart';
import 'package:isar/isar.dart';

class MediaDTODbService
    extends BaseMinLocalDBService<PRFMediaDTO, PRFLocalMediaUpload> {
  MediaDTODbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMediaUpload> get collection =>
      dbInstance.pRFLocalMediaUploads;

  @override
  PRFLocalMediaUpload remoteToLocal(PRFMediaDTO remote) => PRFLocalMediaUpload(
    modelUlid: remote.modelUlid,
    model: remote.model,
    path: remote.path,
  );

  Future<List<PRFMediaDTO>> getAllFuture() async {
    return collection.where().findAll().then(
      (localUploads) => localUploads
          .map(
            (local) => PRFMediaDTO(
              model: local.model,
              modelUlid: local.modelUlid,
              path: local.path,
              name: Misc.getFileName(local.path),
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteByKeys(String key, String path) async {
    await dbInstance.writeTxn(() async {
      await collection
          .filter()
          .modelUlidEqualTo(key)
          .pathEqualTo(path)
          .deleteAll();
    });
  }
}
