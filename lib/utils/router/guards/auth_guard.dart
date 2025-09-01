import 'package:app/services/_index.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final token = getIt<HiveService>().auth.retrieveToken();
    final isLoggedOut = getIt<HiveService>().auth.isLoggedOut();

    if (token != null && !isLoggedOut) {
      resolver.next();
    } else {
      getIt<IsarService>().clearAllTables();
      getIt<HiveService>().clearPrefs();
      router.push(const DecisionRoute());
    }
  }
}
