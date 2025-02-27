import 'package:flutter/material.dart';

class PRFNameInput extends StatelessWidget {
  const PRFNameInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: enabled,
    );
  }
}
