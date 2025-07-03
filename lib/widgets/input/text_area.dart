import 'package:flutter/material.dart';

class PRFTextAreaInput extends StatelessWidget {
  const PRFTextAreaInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
    this.maxLines = 5,
    this.minLines = 5,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(hintText: hintText),
      style: theme.textTheme.bodyMedium,
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
