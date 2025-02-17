import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';

class PRFCircularProgressIndicator extends StatelessWidget {
  const PRFCircularProgressIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? PRFApp.theme().kPrimaryColorV2,
        ),
      ),
    );
  }
}
