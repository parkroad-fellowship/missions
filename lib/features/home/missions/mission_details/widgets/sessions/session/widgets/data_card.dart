import 'package:prf_design/prf_design.dart';
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  const DataCard({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.xxxl,
          ),
          child: PRFFormFieldLabel(label: label, isBold: true),
        ),
        const SizedBox(height: PRFSpacingTokens.xs),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.xxxl,
          ),
          child: PRFTextInput(
            hintText: '',
            controller: TextEditingController(text: value),
            enabled: false,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
