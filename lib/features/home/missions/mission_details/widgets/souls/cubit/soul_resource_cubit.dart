import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class SoulResourceCubit extends ResourceCubit<PRFSoul> {
  SoulResourceCubit({
    required SoulService soulService,
    BaseLocalDBService<PRFSoul, dynamic>? dbService,
  }) : super(service: soulService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['classGroup', 'mission'];

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
