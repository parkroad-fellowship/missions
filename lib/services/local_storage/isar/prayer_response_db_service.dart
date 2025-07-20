import 'package:app/models/local/prf_prayer_response.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class PrayerResponseDbService
    extends BaseLocalDBService<PRFPrayerResponseDTO, PRFLocalPrayerResponse> {
  PrayerResponseDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalPrayerResponse> get collection =>
      dbInstance.pRFLocalPrayerResponses;

  @override
  PRFLocalPrayerResponse remoteToLocal(PRFPrayerResponseDTO remote) {
    return PRFLocalPrayerResponse(
      memberUlid: remote.memberUlid,
      prayerPromptUlid: remote.prayerPromptUlid,
    );
  }

  @override
  Future<List<PRFPrayerResponseDTO>> getAllFuture() async {
    final results = await collection.where().findAll();
    return results
        .map(
          (local) => PRFPrayerResponseDTO(
            memberUlid: local.memberUlid,
            prayerPromptUlid: local.prayerPromptUlid,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteByKey(String key) async {
    await dbInstance.writeTxn(() async {
      await collection.where().prayerPromptUlidEqualTo(key).deleteAll();
    });
  }
}
