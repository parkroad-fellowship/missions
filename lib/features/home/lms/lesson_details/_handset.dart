import 'package:app/enums/prf_completion_status.dart';
import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gaimon/gaimon.dart';

class LessonDetailsHandset extends StatefulWidget {
  const LessonDetailsHandset({
    required this.lessonModule,
    required this.courseUlid,
    required this.moduleUlid,
    super.key,
  });

  final PRFLocalLessonModule lessonModule;
  final String courseUlid;
  final String moduleUlid;

  @override
  State<LessonDetailsHandset> createState() => _LessonDetailsHandsetState();
}

class _LessonDetailsHandsetState extends State<LessonDetailsHandset> {
  PRFLocalLessonModule get lessonModule => widget.lessonModule;
  String get courseUlid => widget.courseUlid;
  String get moduleUlid => widget.moduleUlid;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lesson = lessonModule.lesson;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  lesson.name!.toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Lesson content
            if (lesson.content != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: HtmlWidget(
                    lesson.content!,
                    textStyle: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            // Lesson video
            if (lesson.videoUrl != null)
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(l10n.video),
                  subtitle: Text(lesson.videoUrl!),
                  onTap: () async {
                    final uri = Uri.parse(lesson.videoUrl!);
                    await Misc.openUrl(uri);
                  },
                ),
              ),
            // Lesson document
            if (lesson.documentUrl != null)
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(l10n.document),
                  subtitle: Text(lesson.documentUrl!),
                  onTap: () async {
                    final uri = Uri.parse(lesson.documentUrl!);
                    await Misc.openUrl(uri);
                  },
                ),
              ),
            // Lesson audio
            if (lesson.audioUrl != null)
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(l10n.audio),
                  subtitle: Text(lesson.audioUrl!),
                  onTap: () async {
                    final uri = Uri.parse(lesson.audioUrl!);
                    await Misc.openUrl(uri);
                  },
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            // Complete button
            if (lessonModule.lessonMember == null ||
                (lessonModule.lessonMember != null &&
                    lessonModule.lessonMember!.completionStatus !=
                        PRFCompletionStatus.complete))
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.completed),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        error: (message) {
                          setState(() {
                            _isLoading = false;
                          });
                          Gaimon.error();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => PRFPrimaryButton(
                          onPressed: () async =>
                              context.read<FinishLessonCubit>().finishLesson(
                                lessonUlid: lesson.ulid!,
                                moduleUlid: moduleUlid,
                                courseUlid: courseUlid,
                              ),
                          title: _isLoading ? l10n.completing : l10n.complete,
                          disabled: _isLoading,
                          isLoading: _isLoading ? true : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
