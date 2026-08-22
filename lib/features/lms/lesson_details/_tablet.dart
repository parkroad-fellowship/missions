import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/lesson_details/_shared.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class LessonDetailsTablet extends StatefulWidget {
  const LessonDetailsTablet({
    required this.lessonModuleUlid,
    required this.courseModuleUlid,
    super.key,
  });

  final String lessonModuleUlid;
  final String courseModuleUlid;

  @override
  State<LessonDetailsTablet> createState() => _LessonDetailsTabletState();
}

class _LessonDetailsTabletState extends State<LessonDetailsTablet> {
  late final _form = LessonDetailsFormState(
    lessonModuleUlid: widget.lessonModuleUlid,
  );
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
      buildWhen: (previous, current) => current.maybeWhen(
        mutating: (_, _) => false,
        orElse: () => true,
      ),
      builder: (context, state) {
        final lessonModule = state.maybeWhen(
          listLoaded: (items, _, _) => items.isNotEmpty ? items.first : null,
          orElse: () => null,
        );
        final isCompleted =
            lessonModule?.lessonMember?.completionStatus ==
            PRFCompletionStatus.complete;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.lessonDetails,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.moduleDetailsRoute,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      context.read<LessonResourceCubit>().loadAll(
                        filters: {
                          'lesson_module_id': widget.lessonModuleUlid,
                        },
                      ),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(
                          PRFSpacingTokens.lg,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          error: (message, _) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: PRFEmptyView(
                                label: l10n.lessonDetails,
                                description: message,
                              ),
                            ),
                          ),
                          listLoaded: (items, _, _) {
                            if (items.isEmpty) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.lessonDetails,
                                    description: l10n.noLessonsDesc,
                                  ),
                                ),
                              );
                            }

                            return SliverToBoxAdapter(
                              child: LessonContentCard(
                                lessonModule: items.first,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sidePanel: _buildBrandPanel(context, l10n, theme, isCompleted),
        );
      },
    );
  }

  // The panel keeps its header, stats and completion action visible through
  // every load state — no spinner dead-ends.
  Widget _buildBrandPanel(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    bool isCompleted,
  ) {
    return BlocBuilder<LessonResourceCubit, ResourceState<PRFLessonModule>>(
      builder: (context, state) {
        final lessonModule = state.maybeWhen(
          listLoaded: (items, _, _) => items.isNotEmpty ? items.first : null,
          orElse: () => null,
        );
        final lesson = lessonModule?.lesson;
        final mediaCount = [
          lesson?.videoUrl,
          lesson?.documentUrl,
          lesson?.audioUrl,
        ].where((url) => (url ?? '').trim().isNotEmpty).length;
        final isLoading = state.maybeWhen(
          listLoading: (_) => true,
          orElse: () => false,
        );

        final resolvedCourseModule = context
            .read<ModuleResourceCubit>()
            .state
            .maybeWhen(
              listLoaded: (courseModules, _, _) {
                for (final courseModule in courseModules) {
                  if (courseModule.ulid == widget.courseModuleUlid) {
                    return courseModule;
                  }
                }
                return null;
              },
              orElse: () => null,
            );

        return PRFBrandPanel(
          children: [
            Row(
              children: [
                Expanded(
                  child: PRFPanelSectionLabel(
                    lesson?.name ?? l10n.lessonDetails,
                  ),
                ),
                if (isLoading)
                  const SizedBox.square(
                    dimension: 16,
                    child: PRFCircularProgressIndicator(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Wrap(
              spacing: PRFSpacingTokens.sm,
              runSpacing: PRFSpacingTokens.sm,
              children: [
                LmsStatPill(
                  label: l10n.total,
                  value: mediaCount,
                ),
                LmsStatPill(
                  label: l10n.completed,
                  value: isCompleted ? 1 : 0,
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Media resource tiles on a light card for legibility, or a
            // graceful empty fallback
            if (lessonModule != null && mediaCount > 0)
              Material(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                child: Padding(
                  padding: const EdgeInsets.all(PRFSpacingTokens.md),
                  child: buildLessonMedia(
                    context: context,
                    lessonModule: lessonModule,
                    l10n: l10n,
                  ),
                ),
              )
            else if (!isLoading && lessonModule == null)
              Text(
                l10n.noLessonResources,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
              ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Complete button docked at the bottom of the panel
            _buildCompleteButton(
              lessonModule,
              resolvedCourseModule?.course?.ulid,
              l10n,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompleteButton(
    PRFLessonModule? lessonModule,
    String? courseUlid,
    AppLocalizations l10n,
  ) {
    if (lessonModule == null) {
      return const SizedBox.shrink();
    }

    if (lessonModule.lessonMember == null ||
        (lessonModule.lessonMember != null &&
            lessonModule.lessonMember!.completionStatus !=
                PRFCompletionStatus.complete)) {
      return BlocConsumer<LessonResourceCubit, ResourceState<PRFLessonModule>>(
        listener: (context, state) {
          state.maybeWhen(
            mutating: (_, _) => setState(() {
              _isLoading = true;
            }),
            listLoaded: (_, _, _) {
              if (!_isLoading) return;
              setState(() {
                _isLoading = false;
              });
              Gaimon.success();
              PRFSnackbar.success(context, l10n.completed);
              Navigator.of(context).pop();
            },
            error: (message, _) {
              setState(() {
                _isLoading = false;
              });
              Gaimon.error();
              PRFSnackbar.error(context, message);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => PRFButton(
              variant: PRFButtonVariant.secondary,
              onPressed: () async {
                final moduleUlid = lessonModule.module?.ulid;
                final lessonUlid = lessonModule.lesson?.ulid;

                if (courseUlid == null ||
                    moduleUlid == null ||
                    lessonUlid == null) {
                  PRFSnackbar.error(context, l10n.pleaseWaitBrief);
                  return;
                }

                await context.read<LessonResourceCubit>().finishLesson(
                  lessonUlid: lessonUlid,
                  moduleUlid: moduleUlid,
                  courseUlid: courseUlid,
                );
              },
              title: _isLoading ? l10n.completing : l10n.complete,
              disabled: _isLoading,
              isLoading: _isLoading,
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
