import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    required this.label,
    super.key,
    this.isOptional,
    this.isRequired,
    this.color,
    this.isBold,
  });
  
  final String label;
  final bool? isOptional;
  final bool? isRequired;
  final Color? color;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RichText(
      text: TextSpan(
        text: label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: isBold ?? false ? FontWeight.w700 : FontWeight.w600,
          color: color ?? theme.colorScheme.onSurface,
        ),
        children: [
          if (isRequired ?? false)
            TextSpan(
              text: ' *',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (isOptional ?? false)
            TextSpan(
              text: ' (optional)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
