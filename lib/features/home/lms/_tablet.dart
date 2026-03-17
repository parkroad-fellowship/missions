import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/features/home/lms/widgets/course_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LMSPageTablet extends StatefulWidget {
  const LMSPageTablet({super.key});

  @override
  State<LMSPageTablet> createState() => _LMSPageTabletState();
}

class _LMSPageTabletState extends State<LMSPageTablet> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
          child: CustomScrollView(
            slivers: [
              PRFNavBar(
                title: l10n.learn,
                backgroundColor: theme.colorScheme.surface,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
              SliverToBoxAdapter(
                child:
                    BlocBuilder<CourseResourceCubit, ResourceState<PRFCourse>>(
                      builder: (context, state) => state.maybeWhen(
                        listLoading: () => const Padding(
                          padding: EdgeInsets.only(bottom: PRFSpacingTokens.lg),
                          child: PRFLinearProgressIndicator(),
                        ),
                        orElse: SizedBox.shrink,
                      ),
                    ),
              ),
              StreamBuilder(
                stream: getIt<IsarService>().courses.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: PRFCircularProgressIndicator()),
                    );
                  }

                  final courses = snapshot.data;

                  if (courses != null && courses.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: RefreshIndicator(
                        onRefresh: () =>
                            context.read<CourseResourceCubit>().loadAll(),
                        child: PRFEmptyView(
                          label: l10n.noCourses,
                          description: l10n.pleaseWait,
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: courses!.length,
                    itemBuilder: (context, index) =>
                        CourseActionCard(course: courses[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: PRFSpacingTokens.lg),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
