import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/widgets/course_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class LMSPageHandset extends StatefulWidget {
  const LMSPageHandset({super.key});

  @override
  State<LMSPageHandset> createState() => _LMSPageHandsetState();
}

class _LMSPageHandsetState extends State<LMSPageHandset> {
  @override
  void initState() {
    context.read<CourseResourceCubit>().loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CourseResourceCubit, ResourceState<PRFCourse>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                PRFNavBar(
                  title: l10n.learn,
                  backgroundColor: theme.colorScheme.surface,
                ),
                ...state.maybeWhen(
                  listLoading: () => [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: PRFSpacingTokens.lg),
                        child: PRFLinearProgressIndicator(),
                      ),
                    ),
                  ],
                  listLoaded: (courses, _, _) {
                    if (courses.isEmpty) {
                      return [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: PRFEmptyView(
                            label: l10n.noCourses,
                            description: l10n.pleaseWait,
                          ),
                        ),
                      ];
                    }
                    return [
                      SliverList.separated(
                        itemCount: courses.length,
                        itemBuilder: (context, index) =>
                            CourseActionCard(course: courses[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: PRFSpacingTokens.lg),
                      ),
                    ];
                  },
                  error: (message, _) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text(message)),
                    ),
                  ],
                  orElse: () => [
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
