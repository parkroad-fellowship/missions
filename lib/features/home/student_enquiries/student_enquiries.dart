import 'package:app/features/home/student_enquiries/_handset.dart';
import 'package:app/features/home/student_enquiries/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class StudentEnquiriesPage extends StatelessWidget {
  const StudentEnquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const StudentEnquiriesPageHandset(),
      handset: (context) => const StudentEnquiriesPageHandset(),
      tablet: (context) => const StudentEnquiriesPageTablet(),
    );
  }
}
