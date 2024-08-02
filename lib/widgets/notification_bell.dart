import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.router.pushNamed(PRFSuperAppRouter.announcementsRoute),
      child: CircleAvatar(
        radius: 70.r,
        backgroundColor: Colors.transparent,
        child: const Badge(
          child: Icon(
            Icons.notifications_none,
            size: 30,
          ),
        ),
      ),
    );
  }
}
