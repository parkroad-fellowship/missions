import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
  String get lessonModuleUlid => widget.lessonModuleUlid;
  String get courseModuleUlid => widget.courseModuleUlid;

  @override
  void initState() {
    super.initState();

    final lessonCubit = context.read<LessonResourceCubit>();
    if (!lessonCubit.currentItems.any((l) => l.ulid == lessonModuleUlid)) {
      lessonCubit.loadAll();
    }
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
        final isCompleted =
            lessonModule?.lessonMember?.completionStatus ==
            PRFCompletionStatus.complete;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.88),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    PRFBrandedNavBar(
                      title: l10n.lessonDetails,
                      onBack: () => context.router.popUntilRouteWithPath(
                        PRFSuperAppRouter.moduleDetailsRoute,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.xs,
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.lg,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson?.name ?? l10n.lessonDetails,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Wrap(
                              spacing: PRFSpacingTokens.xs,
                              runSpacing: PRFSpacingTokens.xs,
                              children: [
                                _LessonStatPill(
                                  label: l10n.total,
                                  value: mediaCount,
                                ),
                                _LessonStatPill(
                                  label: l10n.completed,
                                  value: isCompleted ? 1 : 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<LessonResourceCubit>().loadAll(
                    filters: {'lesson_module_id': lessonModuleUlid},
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
                                    description: l10n.pleaseWait,
                                  ),
                                ),
                              );
                            }

                            final resolvedLessonModule = items.first;
                            final resolvedCourseModule = context
                                .read<ModuleResourceCubit>()
                                .state
                                .maybeWhen(
                                  listLoaded: (courseModules, _, _) {
                                    for (final courseModule in courseModules) {
                                      if (courseModule.ulid ==
                                          courseModuleUlid) {
                                        return courseModule;
                                      }
                                    }
                                    return null;
                                  },
                                  orElse: () => null,
                                );
                            return SliverList.list(
                              children: [
                                _LessonContentCard(
                                  lessonModule: resolvedLessonModule,
                                ),
                                const SizedBox(height: PRFSpacingTokens.lg),
                                _buildLessonMedia(
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

  Widget _buildLessonMedia({
    required PRFLessonModule lessonModule,
    required AppLocalizations l10n,
  }) {
    final lesson = lessonModule.lesson;
    final resources = <Widget>[];

    if ((lesson?.videoUrl ?? '').trim().isNotEmpty) {
      resources.add(
        _LessonResourceTile(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.video,
          value: lesson!.videoUrl!,
          onTap: () async {
            final uri = Uri.parse(lesson.videoUrl!);
            await UrlHelper.openUrl(uri);
          },
        ),
      );
    }
    if ((lesson?.documentUrl ?? '').trim().isNotEmpty) {
      resources.add(
        _LessonResourceTile(
          icon: Icons.description_outlined,
          title: l10n.document,
          value: lesson!.documentUrl!,
          onTap: () async {
            final uri = Uri.parse(lesson.documentUrl!);
            await UrlHelper.openUrl(uri);
          },
        ),
      );
    }
    if ((lesson?.audioUrl ?? '').trim().isNotEmpty) {
      resources.add(
        _LessonResourceTile(
          icon: Icons.headphones_rounded,
          title: l10n.audio,
          value: lesson!.audioUrl!,
          onTap: () async {
            final uri = Uri.parse(lesson.audioUrl!);
            await UrlHelper.openUrl(uri);
          },
        ),
      );
    }

    if (resources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.lessonResources,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        ...resources,
      ],
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
                  orElse: () => PRFPrimaryButton(
                    onPressed: () async {
                      final moduleUlid = lessonModule.module?.ulid;
                      final lessonUlid = lessonModule.lesson?.ulid;

                      if (courseUlid == null ||
                          moduleUlid == null ||
                          lessonUlid == null) {
                        PRFSnackbar.error(context, l10n.pleaseWait);
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
                    isLoading: _isLoading ? true : null,
                  ),
                );
              },
            ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _LessonContentCard extends StatelessWidget {
  const _LessonContentCard({required this.lessonModule});

  final PRFLessonModule lessonModule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = lessonModule.lesson;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (lesson?.name ?? '').toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if ((lesson?.content ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: PRFSpacingTokens.md),
              HtmlWidget(
                lesson!.content!,
                textStyle: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonResourceTile extends StatelessWidget {
  const _LessonResourceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Material(
          color: PRFColors.transparent,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(title),
            subtitle: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.open_in_new_rounded,
              color: theme.colorScheme.primary,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class _LessonStatPill extends StatelessWidget {
  const _LessonStatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
