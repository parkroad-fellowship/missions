import 'package:app/features/home/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/home/lms/widgets/module_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class ModuleDetailsPageHandset extends StatefulWidget {
  const ModuleDetailsPageHandset({
    required this.courseModuleUlid,
    super.key,
  });

  final String courseModuleUlid;

  @override
  State<ModuleDetailsPageHandset> createState() =>
      _ModuleDetailsPageHandsetState();
}

class _ModuleDetailsPageHandsetState extends State<ModuleDetailsPageHandset> {
  String get courseModuleUlid => widget.courseModuleUlid;

  @override
  void initState() {
    context.read<ModuleResourceCubit>().loadAll(
      filters: {'course_module_ulid': courseModuleUlid},
    );
    context.read<LessonResourceCubit>().loadAll(
      filters: {'course_module_ulid': courseModuleUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.moduleDetails,
              backgroundColor: theme.colorScheme.surface,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.courseDetailsRoute,
              ),
              actions: [
                BlocBuilder<
                  ModuleResourceCubit,
                  ResourceState<PRFCourseModule>
                >(
                  builder: (context, state) {
                    final courseModule = state.maybeWhen(
                      listLoaded: (items, _, _) =>
                          items.isNotEmpty ? items.first : null,
                      orElse: () => null,
                    );
                    if (courseModule == null) {
                      return const SizedBox(
                        width: PRFSpacingTokens.xxxl,
                        height: 36,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.md,
                        vertical: PRFSpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.13,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.percentage(
                          courseModule.memberModule?.percentComplete.toInt() ??
                              0,
                        ),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Module name
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.xl,
                ),
                child:
                    BlocBuilder<
                      ModuleResourceCubit,
                      ResourceState<PRFCourseModule>
                    >(
                      builder: (context, state) {
                        final courseModule = state.maybeWhen(
                          listLoaded: (items, _, _) =>
                              items.isNotEmpty ? items.first : null,
                          orElse: () => null,
                        );
                        if (courseModule == null) {
                          return const Center(
                            child: PRFCircularProgressIndicator(),
                          );
                        }
                        return Text(
                          courseModule.module?.name ?? '',
                          style: theme.textTheme.headlineMedium,
                        );
                      },
                    ),
              ),
            ),
            // Module description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.xl,
                ),
                child:
                    BlocBuilder<
                      ModuleResourceCubit,
                      ResourceState<PRFCourseModule>
                    >(
                      builder: (context, state) {
                        final courseModule = state.maybeWhen(
                          listLoaded: (items, _, _) =>
                              items.isNotEmpty ? items.first : null,
                          orElse: () => null,
                        );
                        if (courseModule == null) {
                          return const Center(
                            child: PRFCircularProgressIndicator(),
                          );
                        }
                        return Text(
                          courseModule.module?.description ?? '',
                          style: theme.textTheme.bodyMedium,
                        );
                      },
                    ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xxl),
            ),
            // Lessons header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.xl,
                ),
                child: Text(
                  l10n.lessons,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xl),
            ),
            // Lessons list
            BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
              builder: (context, state) {
                return state.maybeWhen(
                  listLoading: () => const SliverToBoxAdapter(
                    child: Center(child: PRFCircularProgressIndicator()),
                  ),
                  listLoaded: (lessonModules, _, _) {
                    if (lessonModules.isEmpty) {
                      return SliverToBoxAdapter(
                        child: PRFEmptyView(
                          label: l10n.noLessons,
                          description: l10n.pleaseWait,
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: lessonModules.length,
                      itemBuilder: (context, index) => ModuleDetailsActionCard(
                        lessonModule: lessonModules[index],
                        courseModuleUlid: courseModuleUlid,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: PRFSpacingTokens.lg),
                    );
                  },
                  error: (message, _) => SliverToBoxAdapter(
                    child: Center(child: Text(message)),
                  ),
                  orElse: () => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
