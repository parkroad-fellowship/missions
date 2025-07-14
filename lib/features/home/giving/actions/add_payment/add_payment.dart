import 'package:app/features/home/giving/actions/add_payment/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddPaymentView extends StatelessWidget {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const AppPaymentHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const AppPaymentHandset(),
      ),
    );
  }
}
