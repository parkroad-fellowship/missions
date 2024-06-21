import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LMSPageHandset extends StatefulWidget {
  const LMSPageHandset({super.key});

  @override
  State<LMSPageHandset> createState() => _LMSPageHandsetState();
}

class _LMSPageHandsetState extends State<LMSPageHandset> {
  @override
  void initState() {
    context.read<GetCoursesCubit>().getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.learn,
          style: CustomTextTheme.customTextTheme()
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
    );
  }
}
