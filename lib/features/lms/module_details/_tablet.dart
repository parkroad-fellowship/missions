import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/module_details/_shared.dart';
import 'package:app/features/lms/widgets/module_details_action_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class ModuleDetailsPageTablet extends StatefulWidget {
  const ModuleDetailsPageTablet({required this.courseModuleUlid, super.key});
  final String courseModuleUlid;

  @override
  State<ModuleDetailsPageTablet> createState() =>
      _ModuleDetailsPageTabletState();
}

class _ModuleDetailsPageTabletState extends State<ModuleDetailsPageTablet> {
  late final _form = ModuleDetailsFormState(
    courseModuleUlid: widget.courseModuleUlid,
  );

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

    return BlocBuilder<ModuleResourceCubit, ResourceState<PRFCourseModule>>(
      builder: (context, moduleState) {
        return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
          builder: (context, lessonState) {
            final courseModule = moduleState.maybeWhen(
              listLoaded: (items, _, _) =>
                  items.isNotEmpty ? items.first : null,
              orElse: () => null,
            );
            final lessonModules = lessonState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFLessonModule>.empty,
            );
            final completedCount = lessonModules
                .where(
                  (lessonModule) =>
                      lessonModule.lessonMember?.completionStatus ==
                      PRFCompletionStatus.complete,
                )
                .length;

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Column - Description + Lessons Grid (flex: 3)
                        Expanded(
                          flex: 3,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await context
                                  .read<ModuleResourceCubit>()
                                  .loadAll(
                                    filters: {'ulid': widget.courseModuleUlid},
                                  )
                                  .then((_) {
                                    final module = context
                                        .read<ModuleResourceCubit>()
                                        .currentItems
                                        .firstWhereOrNull(
                                          (module) =>
                                              module.ulid ==
                                              widget.courseModuleUlid,
                                        );
                                    if (module != null) {
                                      context
                                          .read<LessonResourceCubit>()
                                          .loadAll(
                                            filters: {
                                              'module_ulid':
                                                  module.module?.ulid,
                                            },
                                          );
                                    }
                                  });
                            },
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              slivers: [
                                if ((courseModule?.module?.description ?? '')
                                    .trim()
                                    .isNotEmpty)
                                  SliverPadding(
                                    padding: const EdgeInsets.all(
                                      PRFSpacingTokens.lg,
                                    ),
                                    sliver: SliverToBoxAdapter(
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                          PRFSpacingTokens.md,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            PRFRadiusTokens.md,
                                          ),
                                          border: Border.all(
                                            color: theme.colorScheme.outline
                                                .withValues(alpha: 0.12),
                                          ),
                                        ),
                                        child: Text(
                                          courseModule!.module!.description,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                height: 1.4,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.lg,
                                  ),
                                  sliver: lessonState.maybeWhen(
                                    orElse: () => const SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Center(
                                        child: PRFCircularProgressIndicator(),
                                      ),
                                    ),
                                    listLoading: (_) =>
                                        const SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Center(
                                            child:
                                                PRFCircularProgressIndicator(),
                                          ),
                                        ),
                                    error: (message, _) => SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: PRFEmptyView(
                                          label: l10n.noLessons,
                                          description: message,
                                        ),
                                      ),
                                    ),
                                    listLoaded: (values, _, _) {
                                      if (values.isEmpty) {
                                        return SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: PRFEmptyView(
                                              label: l10n.noLessons,
                                              description: l10n.pleaseWait,
                                            ),
                                          ),
                                        );
                                      }

                                      return SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: columns,
                                              crossAxisSpacing:
                                                  PRFSpacingTokens.lg,
                                              mainAxisSpacing:
                                                  PRFSpacingTokens.lg,
                                              childAspectRatio: 1.4,
                                            ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            return ModuleDetailsActionCard(
                                                  lessonModule: values[index],
                                                  courseModuleUlid:
                                                      widget.courseModuleUlid,
                                                )
                                                .animate(
                                                  delay: Duration(
                                                    milliseconds: 70 * index,
                                                  ),
                                                )
                                                .fadeIn(
                                                  duration: PRFMotionTokens
                                                      .enterShort,
                                                )
                                                .slideY(
                                                  begin: 0.22,
                                                  end: 0,
                                                  duration: PRFMotionTokens
                                                      .enterMedium,
                                                  curve: Curves.easeOutCubic,
                                                );
                                          },
                                          childCount: values.length,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Vertical Divider
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.12,
                          ),
                        ),

                        // Right Column - Module Details (flex: 2)
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.lg,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () =>
                                          context.router.popUntilRouteWithPath(
                                            PRFSuperAppRouter
                                                .courseDetailsRoute,
                                          ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.moduleDetails,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    if (courseModule != null)
                                      ModuleProgressBadge(
                                        value: l10n.percentage(
                                          courseModule
                                                  .memberModule
                                                  ?.percentComplete
                                                  .toInt() ??
                                              0,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: PRFSpacingTokens.xl),

                                // Module Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.xl,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.md,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseModule?.module?.name ??
                                            l10n.moduleDetails,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: PRFSpacingTokens.xl,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LmsStatPill(
                                              label: l10n.total,
                                              value: lessonModules.length,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: PRFSpacingTokens.sm,
                                          ),
                                          Expanded(
                                            child: LmsStatPill(
                                              label: l10n.completed,
                                              value: completedCount,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Additional visual help
                                Center(
                                  child: Icon(
                                    Icons.play_circle_outline_rounded,
                                    size: 64,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Text(
                                  'Study your Lessons',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: PRFSpacingTokens.sm),
                                Text(
                                  'Each lesson includes informative texts and resources to grow. Tap lessons on the left list to begin studying.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
