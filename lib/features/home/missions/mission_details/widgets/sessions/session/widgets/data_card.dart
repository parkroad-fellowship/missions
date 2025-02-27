import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataCard extends StatelessWidget {
  const DataCard({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormFieldLabel(label: label, isBold: true),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: PRFTextInput(
            hintText: '',
            controller: TextEditingController(text: value),
            enabled: false,
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
