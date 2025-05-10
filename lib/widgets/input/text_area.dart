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
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
