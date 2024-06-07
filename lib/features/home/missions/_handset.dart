import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';

class MissionsPageHandset extends StatefulWidget {
  const MissionsPageHandset({super.key});

  @override
  State<MissionsPageHandset> createState() => _MissionsPageHandsetState();
}

class _MissionsPageHandsetState extends State<MissionsPageHandset> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.missions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
    );
  }
}
