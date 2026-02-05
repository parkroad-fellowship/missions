import 'package:app/services/local_auth_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/router/router.dart';
import 'package:get_it/get_it.dart';

/// Core module for registering essential app infrastructure services.
///
/// Includes:
/// - Router
/// - Hive (local key-value storage)
/// - Isar (local database)
/// - Local authentication
class CoreModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<PRFSuperAppRouter>(PRFSuperAppRouter())
      ..registerSingleton<HiveService>(HiveService())
      ..registerSingleton<IsarService>(IsarService())
      ..registerSingleton<LocalAuthService>(LocalAuthService());
  }

  static Future<void> initializeDatabases(GetIt getIt) async {
    await getIt<HiveService>().initBoxes();
    await getIt<IsarService>().initDatabase();
  }
}
