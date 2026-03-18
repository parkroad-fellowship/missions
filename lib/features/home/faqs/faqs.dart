import 'package:app/features/home/faqs/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MemberFAQPage extends StatelessWidget {
  const MemberFAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MemberFAQPageHandset();
  }
}
