import 'package:app/features/home/lms/widgets/module_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ModuleDetailsPageHandset extends StatefulWidget {
  const ModuleDetailsPageHandset({
    required this.courseModuleUlid,
    required this.moduleUlid,
    required this.courseUlid,
    super.key,
  });

  final String courseModuleUlid;
  final String moduleUlid;
  final String courseUlid;

  @override
  State<ModuleDetailsPageHandset> createState() =>
      _ModuleDetailsPageHandsetState();
}

class _ModuleDetailsPageHandsetState extends State<ModuleDetailsPageHandset> {
  String get courseModuleUlid => widget.courseModuleUlid;

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
                StreamBuilder<PRFLocalCourseModule?>(
                  stream: getIt<LocalDBService>().getCourseModule(
                    courseModuleUlid: courseModuleUlid,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final courseModule = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
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
                          courseModule?.memberModule?.percentComplete
                                  ?.toInt() ??
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamBuilder<PRFLocalCourseModule?>(
                  stream: getIt<LocalDBService>().getCourseModule(
                    courseModuleUlid: courseModuleUlid,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: PRFCircularProgressIndicator(),
                      );
                    }
                    final courseModule = snapshot.data;
                    return Text(
                      courseModule?.module.name ?? '',
                      style: theme.textTheme.headlineMedium,
                    );
                  },
                ),
              ),
            ),
            // Module description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamBuilder<PRFLocalCourseModule?>(
                  stream: getIt<LocalDBService>().getCourseModule(
                    courseModuleUlid: courseModuleUlid,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: PRFCircularProgressIndicator(),
                      );
                    }
                    final course = snapshot.data;
                    return Text(
                      course?.module.description ?? '',
                      style: theme.textTheme.bodyMedium,
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            // Lessons header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.lessons,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Lessons list
            StreamBuilder<List<PRFLocalLessonModule>>(
              stream: getIt<LocalDBService>().getLessonModules(
                moduleUlid: widget.moduleUlid,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: PRFCircularProgressIndicator()),
                  );
                }

                final lessonModules = snapshot.data;

                if (lessonModules != null && lessonModules.isEmpty) {
                  return SliverToBoxAdapter(
                    child: PRFEmptyView(
                      label: l10n.noLessons,
                      description: l10n.pleaseWait,
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: lessonModules!.length,
                  itemBuilder: (context, index) => ModuleDetailsActionCard(
                    lessonModule: lessonModules[index],
                    courseUlid: widget.courseUlid,
                    moduleUlid: widget.moduleUlid,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
