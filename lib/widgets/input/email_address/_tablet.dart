import 'package:flutter/material.dart';

class PRFEmailInputTablet extends StatelessWidget {
  const PRFEmailInputTablet({
    required this.hintText,
    required this.emailController,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController emailController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: emailController,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.titleMedium, // Larger text for tablet
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.email_outlined,
          size: 24, // Larger icon for tablet
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20, // Increased padding for tablet
        ),
      ),
    );
  }
}
