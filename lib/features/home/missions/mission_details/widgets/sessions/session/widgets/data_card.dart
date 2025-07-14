import 'package:app/shared_widgets/_index.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: FormFieldLabel(label: label, isBold: true),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
