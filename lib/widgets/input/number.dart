import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PRFNumberInput extends StatelessWidget {
  const PRFNumberInput({
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      enabled: !isLoading,
    );
  }
}
