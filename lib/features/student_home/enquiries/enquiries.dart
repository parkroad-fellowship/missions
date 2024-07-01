import 'package:app/features/student_home/enquiries/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class EnquiriesPage extends StatelessWidget {
  const EnquiriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const EnquiriesPageHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const EnquiriesPageHandset(),
      ),
    );
  }
}
