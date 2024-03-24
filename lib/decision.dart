import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  void _redirectToPage(BuildContext context, {required String routeName}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => GoRouter.of(context).go(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<dynamic>(PRFSuperAppConfig.instance!.values.hiveBox)
              .listenable(),
      builder: (context, _, __) {
        final accessToken = HiveServiceImplementation().retrieveToken();

        if (accessToken == null) {
          _redirectToPage(
            context,
            routeName: PRFSuperAppRouter.authRoute,
          );
        } else {
          _redirectToPage(
            context,
            routeName: PRFSuperAppRouter.landingPage,
          );
        }
        return Scaffold(
          body: Center(
            child: ExtendedImage.asset(
              'assets/images/logo-white.png',
              width: 222,
              cacheRawData: true,
            ),
          ),
        );
      },
    );
  }
}
