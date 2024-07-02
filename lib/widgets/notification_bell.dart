import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          context.router.pushNamed(PRFSuperAppRouter.announcementsRoute),
      icon: const Icon(
        Icons.notifications_none,
        color: Colors.black,
      ),
    );
  }
}
