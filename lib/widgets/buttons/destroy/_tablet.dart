import 'package:app/widgets/progress/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class PRFDestroyButtonTablet extends StatelessWidget {
  const PRFDestroyButtonTablet({
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
      child: ElevatedButton(
        onPressed: (disabled || (isLoading ?? false)) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          disabledBackgroundColor: theme.colorScheme.error.withValues(
            alpha: 0.4,
          ),
          disabledForegroundColor: theme.colorScheme.onError.withValues(
            alpha: 0.7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Larger border radius for tablet
          ),
          elevation: 3, // Slightly more elevation for tablet
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading ?? false) ...[
              const SizedBox(
                height: 20, // Larger loading indicator for tablet
                width: 20,
                child: PRFCircularProgressIndicator(color: Colors.white),
              ),
              const SizedBox(width: 12), // More spacing for tablet
            ],
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                // Larger text style for tablet
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
