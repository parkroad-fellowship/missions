import 'package:flutter/material.dart';

class PRFNameInput extends StatelessWidget {
  const PRFNameInput({
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
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: !isLoading,
    );
  }
}
