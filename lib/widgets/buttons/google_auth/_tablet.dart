import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleAuthButtonTablet extends StatelessWidget {
  const GoogleAuthButtonTablet({
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
          backgroundColor: Colors.white,
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outline,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Larger border radius for tablet
          ),
          elevation: 2, // Slightly more elevation for tablet
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading ?? false)
              SizedBox(
                height: 24, // Larger loading indicator for tablet
                width: 24,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              )
            else
              SvgPicture.asset(
                'assets/images/authentication/google_logo.svg',
                height: 24, // Larger icon for tablet
                width: 24,
              ),
            const SizedBox(width: 16), // More spacing for tablet
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                // Larger text style for tablet
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
