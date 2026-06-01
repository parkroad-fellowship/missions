import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/models/remote/prayer/prf_soul_dto.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class SoulResourceCubit extends ResourceCubit<PRFSoul> {
  SoulResourceCubit({
    required SoulService soulService,
    required HiveService hiveService,
  }) : super(service: soulService, dbService: hiveService.souls);

  @override
  List<String> get defaultIncludes => ['classGroup', 'mission'];

  /// Create a soul.
  Future<void> createSoul({required PRFSoulDTO data}) async {
    await create(data: data.toJson());
  }

  /// Update a soul.
  Future<void> updateSoul({
    required String ulid,
    required PRFSoulDTO data,
  }) async {
    await update(
      id: ulid,
      data: data.toJson(),
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete a soul.
  Future<void> deleteSoul(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }
}
