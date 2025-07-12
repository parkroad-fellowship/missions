import 'package:flutter/material.dart';

class PRFTextAreaInputTablet extends StatelessWidget {
  const PRFTextAreaInputTablet({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
    this.maxLines = 6, // Increased for tablet
    this.minLines = 4, // Increased for tablet
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
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      style: theme.textTheme.titleMedium?.copyWith(
        // Larger text for tablet
        color: theme.colorScheme.onSurface,
        height: 1.5,
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
        alignLabelWithHint: true,
      ),
    );
  }
}
