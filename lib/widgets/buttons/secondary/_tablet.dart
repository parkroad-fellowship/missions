import 'package:app/widgets/progress/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class PRFSecondaryButtonTablet extends StatelessWidget {
  const PRFSecondaryButtonTablet({
    required this.onPressed,
    required this.title,
    required this.disabled,
    super.key,
    this.isLoading,
  });

  final VoidCallback onPressed;
  final String title;
  final bool disabled;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 72, // Increased height for tablet
      child: OutlinedButton(
        onPressed: (disabled || (isLoading ?? false)) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
          disabledForegroundColor: theme.colorScheme.primary.withValues(
            alpha: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Larger border radius for tablet
          ),
          elevation: 1, // Slight elevation for tablet
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading ?? false) ...[
              SizedBox(
                height: 20, // Larger loading indicator for tablet
                width: 20,
                child: PRFCircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12), // More spacing for tablet
            ],
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                // Larger text style for tablet
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
