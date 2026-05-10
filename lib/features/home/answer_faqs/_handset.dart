import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AnswerFAQsPageHandset extends StatelessWidget {
  const AnswerFAQsPageHandset({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          PRFBrandedNavBar(title: l10n.answerFaqs),
          const Text('Answer FAQs Page'),
        ],
      ),
    );
  }
}
