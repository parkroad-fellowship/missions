import 'package:app/features/home/landing/_handset.dart';
import 'package:app/features/home/landing/_tablet.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:logger/logger.dart';

@RoutePage()
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      await getIt<NotificationService>().requestPermissions();
      await getIt<NotificationService>().init();

      await getIt<NotificationService>().scheduleGivingNotification();
    } catch (e) {
      Logger().e('NotificationService init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const LandingPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const LandingPageHandset(),
      ),
    );
  }
}
