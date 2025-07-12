import 'package:flutter/material.dart';

class PRFPasswordInputTablet extends StatelessWidget {
  const PRFPasswordInputTablet({
    required this.hintText,
    required this.hidePasswordNotifier,
    required this.passwordController,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final ValueNotifier<bool> hidePasswordNotifier;
  final TextEditingController passwordController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: hidePasswordNotifier,
      builder: (context, hidePassword, child) => TextFormField(
        controller: passwordController,
        enabled: enabled,
        obscureText: hidePassword,
        keyboardType: TextInputType.visiblePassword,
        style: theme.textTheme.titleMedium, // Larger text for tablet
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.titleMedium?.copyWith(
            // Larger hint text
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 24, // Larger icon for tablet
          ),
          suffixIcon: IconButton(
            onPressed: () {
              hidePasswordNotifier.value = !hidePassword;
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 24, // Larger icon for tablet
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, // Increased horizontal padding for tablet
            vertical: 20, // Increased vertical padding for tablet
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Larger border radius for tablet
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
