import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

/// Read-only placeholder view showing how funds are intended to be used.
class RequisitionsView extends StatelessWidget {
  const RequisitionsView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return const PRFEmptyView(
      label: 'Requisitions',
      description: 'Fund allocation details will appear here.',
      icon: Icons.receipt_long_outlined,
    );
  }
}
