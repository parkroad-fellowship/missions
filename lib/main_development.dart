import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      hiveBox: '--prf-super-app-${Misc.getSluggedAppVersion()}',
      baseDomain: '127.0.0.1:8000',
      urlScheme: 'http',
      socketDomain: 'prf-sockets.test',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'ws',
      socketPort: 9000,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async => bootstrap(
      () => MultiBlocProvider(
        providers: Singletons.registerCubits(),
        child: const PRFSuperApp(),
      ),
    ),
  );
}
