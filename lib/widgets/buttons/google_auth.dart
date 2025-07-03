import 'package:app/utils/_index.dart';
import 'package:app/widgets/progress/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({
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
      child: OutlinedButton.icon(
        style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: (isLoading ?? false) ? null : onPressed,
        label: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(PRFTheme.primaryColor),
          ),
        ),
        icon: (isLoading ?? false)
            ? const SizedBox(
                height: 16,
                width: 16,
                child: PRFCircularProgressIndicator(
                  color: Color(PRFTheme.primaryColor),
                ),
              )
            : SvgPicture.asset(
                'assets/images/authentication/google_logo.svg',
              ),
      ),
    );
  }
}
