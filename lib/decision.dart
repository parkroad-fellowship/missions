import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

@RoutePage()
class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  void _redirectToPage(
    BuildContext context,
    String routeName,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.router.pushNamed(routeName),
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
            PRFSuperAppRouter.signInRoute,
          );
        } else {
          _redirectToPage(
            context,
            PRFSuperAppRouter.landingRoute,
          );
        }
        return Scaffold(
          body: Center(
            child: ExtendedImage.asset(
              'assets/images/app-icon.png',
              width: 222,
              cacheRawData: true,
            ),
          ),
        );
      },
    );
  }
}
