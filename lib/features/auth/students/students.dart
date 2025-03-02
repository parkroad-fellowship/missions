import 'package:app/features/auth/students/_handset.dart';
import 'package:app/features/auth/students/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class StudentIntroPage extends StatelessWidget {
  const StudentIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const StudentIntroPageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const StudentIntroPageHandset(),
      ),
    );
  }
}
