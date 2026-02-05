import 'package:app/features/home/shared/cubit/theme_cubit.dart';
import 'package:app/services/local_auth_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Core module for registering essential app infrastructure services.
///
/// Includes:
/// - Router
/// - Hive (local key-value storage)
/// - Isar (local database)
/// - Local authentication
/// - Theme management
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

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<ThemeCubit>(
        create: (context) => ThemeCubit(hiveService: getIt()),
      ),
    ];
  }
}
