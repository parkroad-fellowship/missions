import 'package:flutter/material.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<SoulsViewHandset> createState() => _SoulsViewHandsetState();
}

class _SoulsViewHandsetState extends State<SoulsViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
