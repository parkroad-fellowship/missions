import 'package:app/widgets/progress/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class PRFPrimaryButton extends StatelessWidget {
  const PRFPrimaryButton({
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
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton(
        onPressed: (disabled || (isLoading ?? false)) ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading ?? false) ...[
              const SizedBox(
                height: 16,
                width: 16,
                child: PRFCircularProgressIndicator(color: Colors.white),
              ),
              const SizedBox(width: 8),
            ] else
              const SizedBox.shrink(),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
