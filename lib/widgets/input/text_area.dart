import 'package:flutter/material.dart';

class PRFTextAreaInput extends StatelessWidget {
  const PRFTextAreaInput({
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
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: enabled,
      minLines: 5,
      maxLines: 5,
    );
  }
}
