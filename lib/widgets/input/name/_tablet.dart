import 'package:flutter/material.dart';

class PRFNameInputTablet extends StatelessWidget {
  const PRFNameInputTablet({
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
    final theme = Theme.of(context);

    return TextFormField(
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      controller: controller,
      enabled: enabled,
      style: theme.textTheme.titleMedium?.copyWith(
        // Larger text for tablet
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          // Larger hint text
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16,
          ), // Larger border radius for tablet
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: .2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: .2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: .1),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, // Increased horizontal padding for tablet
          vertical: 20, // Increased vertical padding for tablet
        ),
      ),
    );
  }
}
