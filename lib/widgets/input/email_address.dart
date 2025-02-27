import 'package:flutter/material.dart';

class PRFEmailInput extends StatelessWidget {
  const PRFEmailInput({
    required this.hintText,
    required this.emailController,
    super.key,
    this.enabled = false,
  });

  final String hintText;
  final TextEditingController emailController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: emailController,
      enabled: enabled,
    );
  }
}
