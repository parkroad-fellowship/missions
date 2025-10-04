import 'package:app/l10n/l10n.dart';
import 'package:app/shared_widgets/navbar/navbar.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MissionsWrappedHandset extends StatefulWidget {
  const MissionsWrappedHandset({super.key});

  @override
  State<MissionsWrappedHandset> createState() => _MissionsWrappedHandsetState();
}

class _MissionsWrappedHandsetState extends State<MissionsWrappedHandset> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Navigation Bar
            PRFNavBar(
              title: l10n.impact(DateTime.now().year),
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              backgroundColor: theme.colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}
