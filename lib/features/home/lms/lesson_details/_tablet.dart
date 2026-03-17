import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/features/home/lms/cubit/get_lesson_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/course/prf_lesson_module.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gaimon/gaimon.dart';

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
  String get lessonModuleUlid => widget.lessonModuleUlid;
  String get courseModuleUlid => widget.courseModuleUlid;

  @override
  void initState() {
    super.initState();
    context.read<GetLessonCubit>().getLesson(lessonModuleId: lessonModuleUlid);
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.lessonDetails,
              backgroundColor: theme.colorScheme.surface,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.moduleDetailsRoute,
              ),
            ),
            // Lesson name
            SliverToBoxAdapter(
              child: SingleStreamWrapper<PRFLocalLessonModule?>(
                stream: getIt<IsarService>().lessonModules.itemStream,
                widget: (context, lessonModule) {
                  if (lessonModule == null) {
                    return const Center(
                      child: PRFCircularProgressIndicator(),
                    );
                  }
                  final lesson = lessonModule.lesson;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.xl,
                    ),
                    child: Text(
                      lesson.name!.toUpperCase(),
                      style: theme.textTheme.headlineMedium,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xl),
            ),

            // Lesson content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.xl,
                ),
                child: SingleStreamWrapper<PRFLocalLessonModule?>(
                  stream: getIt<IsarService>().lessonModules.itemStream,
                  widget: (context, lessonModule) {
                    if (lessonModule == null) {
                      return const Center(
                        child: PRFCircularProgressIndicator(),
                      );
                    }
                    final lesson = lessonModule.lesson;

                    return lesson.content != null
                        ? HtmlWidget(
                            lesson.content!,
                            textStyle: theme.textTheme.bodyMedium,
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
            // Lesson video
            SliverToBoxAdapter(
              child: SingleStreamWrapper<PRFLocalLessonModule?>(
                stream: getIt<IsarService>().lessonModules.itemStream,
                widget: (context, lessonModule) {
                  if (lessonModule == null) {
                    return const Center(
                      child: PRFCircularProgressIndicator(),
                    );
                  }
                  final lesson = lessonModule.lesson;

                  return lesson.videoUrl != null
                      ? ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.xl,
                          ),
                          title: Text(l10n.video),
                          subtitle: Text(lesson.videoUrl!),
                          onTap: () async {
                            final uri = Uri.parse(lesson.videoUrl!);
                            await UrlHelper.openUrl(uri);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),

            // Lesson document
            SliverToBoxAdapter(
              child: SingleStreamWrapper<PRFLocalLessonModule?>(
                stream: getIt<IsarService>().lessonModules.itemStream,
                widget: (context, lessonModule) {
                  if (lessonModule == null) {
                    return const Center(
                      child: PRFCircularProgressIndicator(),
                    );
                  }
                  final lesson = lessonModule.lesson;

                  return lesson.documentUrl != null
                      ? ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.xl,
                          ),
                          title: Text(l10n.document),
                          subtitle: Text(lesson.documentUrl!),
                          onTap: () async {
                            final uri = Uri.parse(lesson.documentUrl!);
                            await UrlHelper.openUrl(uri);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            // Lesson audio
            SliverToBoxAdapter(
              child: SingleStreamWrapper<PRFLocalLessonModule?>(
                stream: getIt<IsarService>().lessonModules.itemStream,
                widget: (context, lessonModule) {
                  if (lessonModule == null) {
                    return const Center(
                      child: PRFCircularProgressIndicator(),
                    );
                  }
                  final lesson = lessonModule.lesson;

                  return lesson.audioUrl != null
                      ? ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.xl,
                          ),
                          title: Text(l10n.audio),
                          subtitle: Text(lesson.audioUrl!),
                          onTap: () async {
                            final uri = Uri.parse(lesson.audioUrl!);
                            await UrlHelper.openUrl(uri);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xxl),
            ),

            // Complete button
            SliverToBoxAdapter(
              child: SingleStreamWrapper(
                stream: getIt<IsarService>().lessonModules.itemStream,
                widget: (context, lessonModule) {
                  if (lessonModule == null) {
                    return const Center(
                      child: PRFCircularProgressIndicator(),
                    );
                  }

                  if (lessonModule.lessonMember == null ||
                      (lessonModule.lessonMember != null &&
                          lessonModule.lessonMember!.completionStatus !=
                              PRFCompletionStatus.complete)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.xl,
                      ),
                      child: BlocConsumer<FinishLessonCubit, FinishLessonState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            loading: () => setState(() {
                              _isLoading = true;
                            }),
                            loaded: () {
                              setState(() {
                                _isLoading = false;
                              });
                              Gaimon.success();
                              PRFSnackbar.success(context, l10n.completed);
                              Navigator.of(context).pop();
                            },
                            error: (message) {
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
                              onPressed: () async => context
                                  .read<FinishLessonCubit>()
                                  .finishLesson(
                                    lessonModuleUlid: lessonModuleUlid,
                                    courseModuleUlid: courseModuleUlid,
                                  ),
                              title: _isLoading
                                  ? l10n.completing
                                  : l10n.complete,
                              disabled: _isLoading,
                              isLoading: _isLoading ? true : null,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
