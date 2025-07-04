import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PRFNumberInput extends StatelessWidget {
  const PRFNumberInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.isLoading = false,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(hintText: hintText),
      style: theme.textTheme.bodyMedium,
      controller: controller,
      enabled: !isLoading,
    );
  }
}
