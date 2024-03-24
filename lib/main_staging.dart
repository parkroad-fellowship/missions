import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/singletons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      urlScheme: 'urlScheme',
      baseDomain: 'baseDomain',
      hiveBox: 'prf-super-app-stg',
    ),
  );

  bootstrap(
    () => MultiBlocProvider(
      providers: Singletons.registerCubits(),
      child: const App(),
    ),
  );
}
