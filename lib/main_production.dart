import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';

void main() {
  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      urlScheme: 'urlScheme',
      baseDomain: 'baseDomain',
      hiveBox: 'prf-super-app',
    ),
  );

  bootstrap(() => const App());
}
