import 'package:flutter/material.dart';

class PRFTextAreaInput extends StatelessWidget {
  const PRFTextAreaInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.isLoading = false,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: !isLoading,
      minLines: 5,
    );
  }
}
