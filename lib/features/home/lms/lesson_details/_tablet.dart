import 'package:app/enums/prf_completion_status.dart';
import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gaimon/gaimon.dart';

class LessonDetailsTablet extends StatefulWidget {
  const LessonDetailsTablet({
    required this.lessonModule,
    required this.courseUlid,
    required this.moduleUlid,
    super.key,
  });

  final PRFLocalLessonModule lessonModule;
  final String courseUlid;
  final String moduleUlid;

  @override
  State<LessonDetailsTablet> createState() => _LessonDetailsTabletState();
}

class _LessonDetailsTabletState extends State<LessonDetailsTablet> {
  PRFLocalLessonModule get lessonModule => widget.lessonModule;
  String get courseUlid => widget.courseUlid;
  String get moduleUlid => widget.moduleUlid;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lesson = lessonModule.lesson;
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 36,)),
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.moduleDetailsRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Text(
                          l10n.lessonDetails,
                          style: Theme.of(context).textTheme.displayLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Visibility(
                          child: Icon(Icons.abc, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    lesson.name!.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              SliverList(
                delegate: SliverChildListDelegate([
                  // Lesson content
                  if (lesson.content != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: HtmlWidget(
                        lesson.content!,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),

                  // Lesson video
                  if (lesson.videoUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.video),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(lesson.videoUrl!)],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.videoUrl!);
                        await Misc.openUrl(uri);
                      },
                    ),

                  // Lesson document
                  if (lesson.documentUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.document),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(lesson.documentUrl!)],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.documentUrl!);
                        await Misc.openUrl(uri);
                      },
                    ),

                  // Lesson audio
                  if (lesson.audioUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.audio),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(lesson.audioUrl!)],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.audioUrl!);
                        await Misc.openUrl(uri);
                      },
                    ),
                  SizedBox(height: 32.h),
                  if (lessonModule.lessonMember == null ||
                      (lessonModule.lessonMember != null &&
                          lessonModule.lessonMember!.completionStatus !=
                              PRFCompletionStatus.complete))
                    BlocConsumer<FinishLessonCubit, FinishLessonState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          loading:
                              () => setState(() {
                                _isLoading = !_isLoading;
                              }),
                          loaded: () {
                            setState(() {
                              _isLoading = !_isLoading;
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
                              _isLoading = !_isLoading;
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
                          orElse:
                              () => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40.w),
                                child: PRFPrimaryButton(
                                  onPressed:
                                      () async => context
                                          .read<FinishLessonCubit>()
                                          .finishLesson(
                                            lessonUlid: lesson.ulid!,
                                            moduleUlid: moduleUlid,
                                            courseUlid: courseUlid,
                                          ),
                                  title:
                                      _isLoading
                                          ? l10n.completing
                                          : l10n.complete,
                                  disabled: _isLoading,
                                  isLoading: _isLoading ? true : null,
                                ),
                              ),
                        );
                      },
                    ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
