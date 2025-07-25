import 'dart:async';

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

  Future<List<PRFLocalSoul>> listParentSouls(
    String parentKey,
  ) async {
    return collection.where().missionUlidEqualTo(parentKey).findAll();
  }

  StreamController<List<PRFLocalSoul>>? _parentStreamController;
  Stream<List<PRFLocalSoul>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalSoul>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalSoul>>.broadcast();
    final entities = await listParentSouls(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
