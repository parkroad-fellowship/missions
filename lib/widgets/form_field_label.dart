import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    required this.label,
    super.key,
    this.isOptional,
    this.isRequired,
    this.color,
    this.isBold,
  });
  final String label;
  final bool? isOptional;
  final bool? isRequired;
  final Color? color;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return RichText(
          text: TextSpan(
            text: label,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: isBold ?? false ? FontWeight.bold : null,
            ),
            children: [
              if (isRequired ?? false)
                TextSpan(
                  text: ' *',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              if (isOptional ?? false)
                TextSpan(
                  text: ' (optional)',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: const Color(0xff939393),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
