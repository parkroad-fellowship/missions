import 'package:app/features/home/giving/actions/add_payment/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddPaymentView extends StatelessWidget {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => const AppPaymentHandset(),
      builder: (_, _) => const AppPaymentHandset(),
    );
  }
}
