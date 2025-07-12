import 'package:app/widgets/buttons/google_auth/_tablet.dart';
import 'package:app/widgets/buttons/secondary/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class PRFSecondaryButton extends StatelessWidget {
  const PRFSecondaryButton({
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
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => GoogleAuthButtonTablet(
        onPressed: onPressed,
        title: title,
        disabled: disabled,
        isLoading: isLoading,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => PRFSecondaryButtonHandset(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
        tablet: (_, _) => GoogleAuthButtonTablet(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
