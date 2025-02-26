import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
              isAlert ?? false
                  ? (disabled || (isLoading ?? false))
                      ? PRFApp.theme().kErrorColor.withValues(alpha: .4)
                      : PRFApp.theme().kErrorColor
                  : (disabled || (isLoading ?? false))
                  ? PRFApp.theme().kBackgroundColor.withValues(alpha: .4)
                  : PRFApp.theme().kBackgroundColor,
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
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: PRFApp.theme().kPrimaryColorV2,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 8),
              ] else
                const SizedBox.shrink(),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
