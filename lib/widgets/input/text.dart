import 'package:flutter/material.dart';

class PRFTextInput extends StatelessWidget {
  const PRFTextInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: enabled,
    );
  }
}
