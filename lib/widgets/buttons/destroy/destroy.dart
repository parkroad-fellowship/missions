import 'package:app/widgets/buttons/destroy/_handset.dart';
import 'package:app/widgets/buttons/primary/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class PRFDestroyButton extends StatelessWidget {
  const PRFDestroyButton({
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
      defaultBuilder: (_, _) => PRFPrimaryButtonTablet(
        onPressed: onPressed,
        title: title,
        disabled: disabled,
        isLoading: isLoading,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => PRFDestroyButtonHandset(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
        tablet: (_, _) => PRFPrimaryButtonTablet(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
