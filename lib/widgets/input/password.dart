import 'package:flutter/material.dart';

class PRFPasswordInput extends StatelessWidget {
  const PRFPasswordInput({
    super.key,
    required this.hintText,
    required this.hidePasswordNotifier,
    required this.passwordController,
     this.enabled = true,
  });

  final String hintText;
  final ValueNotifier<bool> hidePasswordNotifier;
  final TextEditingController passwordController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hidePasswordNotifier,
      builder:
          (context, hidePassword, child) => TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: hidePassword,
            decoration: InputDecoration(
              hintText: hintText,
              suffix: GestureDetector(
                onTap: () {
                  hidePasswordNotifier.value = !hidePassword;
                },
                child: Icon(
                  hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,

                  // size: 24,
                ),
              ),
            ),
            style: Theme.of(context).textTheme.bodySmall,
            controller: passwordController,
            enabled: enabled,
          ),
    );
  }
}
