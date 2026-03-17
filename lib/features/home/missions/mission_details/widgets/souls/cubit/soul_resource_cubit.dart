import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/isar/soul_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class SoulResourceCubit extends ResourceCubit<PRFSoul> {
  SoulResourceCubit({
    required SoulService soulService,
    super.dbService,
  }) : super(service: soulService);

  @override
  List<String> get defaultIncludes => ['classGroup', 'mission'];

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is SoulDbService) {
      await (dbService! as SoulDbService).refreshParentStream(parentKey);
    }
    await dbService?.refreshStream();
  }

  /// Create a soul.
  Future<void> createSoul({required Map<String, dynamic> data}) async {
    await create(data: data);
  }

  /// Update a soul.
  Future<void> updateSoul({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete a soul.
  Future<void> deleteSoul(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }
}
