import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_environment.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helpers/app_version_helper.dart';
import 'package:app/utils/helpers/encryption_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EncryptionHelper.ensureRequiredDefines(EncryptionHelper.requiredProduction);

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      environment: PRFEnvironment.production,
      hiveBox: 'prf-missions--${AppVersionHelper.getSluggedAppVersion()}',
      baseDomain: EncryptionHelper.requiredDefine(EncryptionHelper.baseDomain),
      urlScheme: 'https',
      azureConnString: EncryptionHelper.requiredDefine(
        EncryptionHelper.azureConnString,
      ),
      appId: EncryptionHelper.requiredDefine(EncryptionHelper.appId),
      appSecret: EncryptionHelper.requiredDefine(EncryptionHelper.appSecret),
      hiveEncryptionKey: EncryptionHelper.requiredDefine(
        EncryptionHelper.hiveEncryptionKey,
      ),
      tenantUlid: EncryptionHelper.requiredDefine(EncryptionHelper.tenantUlid),
      socketDomain: EncryptionHelper.requiredDefine(
        EncryptionHelper.socketDomain,
      ),
      socketKey: EncryptionHelper.requiredDefine(EncryptionHelper.socketKey),
      socketScheme: 'wss',
      socketPort: 443,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async => bootstrap(
      () => MultiBlocProvider(
        providers: DIContainer.registerCubits(),
        child: const PRFSuperApp(),
      ),
    ),
  );
}
