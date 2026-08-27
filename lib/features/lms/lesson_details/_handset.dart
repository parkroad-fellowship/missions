import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/lms/lesson_details/_shared.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class LessonDetailsHandset extends StatefulWidget {
  const LessonDetailsHandset({
    required this.lessonModuleUlid,
    required this.courseModuleUlid,
    super.key,
  });

  final String lessonModuleUlid;
  final String courseModuleUlid;

  @override
  State<LessonDetailsHandset> createState() => _LessonDetailsHandsetState();
}

class _LessonDetailsHandsetState extends State<LessonDetailsHandset> {
  late final _form = LessonDetailsFormState(
    lessonModuleUlid: widget.lessonModuleUlid,
  );

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  bool _isLoading = false;

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
        // Same source as the list: pull-to-refresh keeps content visible
        // instead of flashing a full-screen spinner.
        final lessonItems = context.read<LessonResourceCubit>().currentItems;
        final lessonModule = lessonItems.firstWhereOrNull(
        (PRFLessonModule l) => l.ulid == widget.lessonModuleUlid,
      );
        final lesson = lessonModule?.lesson;
        final mediaCount = [
          lesson?.videoUrl,
          lesson?.documentUrl,
          lesson?.audioUrl,
        ].where((url) => (url ?? '').trim().isNotEmpty).length;
        final isCompleted =
            lessonModule?.lessonMember?.completionStatus ==
            PRFCompletionStatus.complete;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              buildLessonDetailsHeader(
                context,
                theme,
                l10n,
                lessonModule,
                mediaCount,
                isCompleted,
                () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.moduleDetailsRoute,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      context.read<LessonResourceCubit>().loadAll(
                        filters: {'lesson_module_id': widget.lessonModuleUlid},
                      ),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.xxl,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) => lessonItems.isEmpty
                              ? const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: PRFCircularProgressIndicator(),
                                  ),
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
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

                            final resolvedLessonModule = items.firstWhere(
                              (PRFLessonModule l) => l.ulid == widget.lessonModuleUlid,
                            );
                            final resolvedCourseModule = context
                                .read<ModuleResourceCubit>()
                                .state
                                .maybeWhen(
                                  listLoaded: (courseModules, _, _) {
                                    for (final courseModule in courseModules) {
                                      if (courseModule.ulid ==
                                          widget.courseModuleUlid) {
                                        return courseModule;
                                      }
                                    }
                                    return null;
                                  },
                                  orElse: () => null,
                                );
                            return SliverList.list(
                              children: [
                                LessonContentCard(
                                  lessonModule: resolvedLessonModule,
                                ),
                                const SizedBox(height: PRFSpacingTokens.lg),
                                buildLessonMedia(
                                  context: context,
                                  lessonModule: resolvedLessonModule,
                                  l10n: l10n,
                                ),
                                const SizedBox(height: PRFSpacingTokens.xl),
                                _buildCompleteButton(
                                  resolvedLessonModule,
                                  resolvedCourseModule?.course?.ulid,
                                  l10n,
                                ),
                              ],
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
      return const Center(child: PRFCircularProgressIndicator());
    }

    if (lessonModule.lessonMember == null ||
        (lessonModule.lessonMember != null &&
            lessonModule.lessonMember!.completionStatus !=
                PRFCompletionStatus.complete)) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.xl,
        ),
        child:
            BlocConsumer<LessonResourceCubit, ResourceState<PRFLessonModule>>(
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
            ),
      );
    }

    return const SizedBox.shrink();
  }
}
