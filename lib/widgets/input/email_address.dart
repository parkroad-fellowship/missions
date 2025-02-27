import 'package:flutter/material.dart';

class PRFEmailInput extends StatelessWidget {
  const PRFEmailInput({
    super.key,
    required this.hintText,
    required TextEditingController emailController,
    required bool isLoading,
  }) : _emailController = emailController,
       _isLoading = isLoading;

  final String hintText;
  final TextEditingController _emailController;
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: hintText),
      style: Theme.of(context).textTheme.bodySmall,
      controller: _emailController,
      enabled: !_isLoading,
    );
  }
}
