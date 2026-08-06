import 'package:app/features/missions/answer_faqs/_handset.dart';
import 'package:app/features/missions/answer_faqs/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class AnswerFAQsPage extends StatelessWidget {
  const AnswerFAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const AnswerFAQsPageHandset(),
      handset: (context) => const AnswerFAQsPageHandset(),
      tablet: (context) => const AnswerFAQsPageTablet(),
    );
  }
}
