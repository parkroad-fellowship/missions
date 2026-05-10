import 'package:app/features/home/answer_faqs/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AnswerFAQsPage extends StatelessWidget {
  const AnswerFAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnswerFAQsPageHandset();
  }
}
