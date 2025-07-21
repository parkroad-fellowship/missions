import 'package:app/models/local/prf_soul.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class SoulDbService extends BaseLocalDBService<PRFSoul, PRFLocalSoul> {
  SoulDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalSoul> get collection => dbInstance.pRFLocalSouls;

  @override
  PRFLocalSoul remoteToLocal(PRFSoul remote) {
    return PRFLocalSoul(
      ulid: remote.ulid,
      fullName: remote.fullName,
      decisionType: remote.decisionType,
      classGroup: PRFLocalClassGroup(
        ulid: remote.classGroup?.ulid,
        name: remote.classGroup?.name,
      ),
      missionUlid: remote.mission!.ulid,
      createdAt: remote.createdAt,
      admissionNumber: remote.admissionNumber,
      notes: remote.notes,
    );
  }

  @override
  Stream<List<PRFLocalSoul>> getByParentKey(String parentKey) {
    return collection
        .where()
        .missionUlidEqualTo(parentKey)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
