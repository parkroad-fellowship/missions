import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PRFNumberInputTablet extends StatelessWidget {
  const PRFNumberInputTablet({
    required this.hintText,
    required this.controller,
    super.key,
    this.isLoading = false,
    this.prefixText,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isLoading;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          // Larger hint text for tablet
          color: theme.colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, // Increased horizontal padding for tablet
          vertical: 20, // Increased vertical padding for tablet
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16,
          ), // Larger border radius for tablet
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      style: theme.textTheme.titleMedium, // Larger text for tablet
      controller: controller,
      enabled: !isLoading,
    );
  }
}
