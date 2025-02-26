import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.title,
    required this.disabled,
    super.key,
    this.isLoading,
    this.isAlert,
    this.height,
  });

  final VoidCallback onPressed;
  final String title;
  final bool disabled;
  final bool? isLoading;
  final bool? isAlert;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialButton(
          color:
              isAlert ?? (disabled || (isLoading ?? false))
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: .4)
                  : Theme.of(context).colorScheme.primary,
          minWidth: double.infinity,
          height: height ?? 55,
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          disabledElevation: 0,
          onPressed: disabled ? () {} : onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Wrap(
            children: [
              if (isLoading ?? false) ...[
                const SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 8),
              ] else
                const SizedBox.shrink(),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        );
      },
    );
  }
}
