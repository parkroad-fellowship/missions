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
import 'package:url_launcher/url_launcher.dart';

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

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Start Navigation Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: true,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.appTheme().kPrimaryColorV2,
                          width: 1.w,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: const EdgeInsets.only(left: 8),
                        onPressed: () => context.router.popUntilRouteWithPath(
                          PRFSuperAppRouter.moduleDetailsRoute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 0.5.sw,
                      child: Text(
                        l10n.lessonDetails,
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
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
                  lesson.name!,
                  style: CustomTextTheme.customTextTheme()
                      .headlineMedium
                      ?.copyWith(fontSize: 52.sp),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  lesson.description!,
                  style: CustomTextTheme.customTextTheme()
                      .bodyLarge
                      ?.copyWith(fontSize: 52.sp),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  l10n.content,
                  style: CustomTextTheme.customTextTheme()
                      .headlineMedium
                      ?.copyWith(fontSize: 52.sp),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Lesson content
                  if (lesson.content != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: HtmlWidget(lesson.content!),
                    ),

                  // Lesson video
                  if (lesson.videoUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.video),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(lesson.videoUrl!),
                        ],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.videoUrl!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),

                  // Lesson document
                  if (lesson.documentUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.document),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(lesson.documentUrl!),
                        ],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.documentUrl!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),

                  // Lesson audio
                  if (lesson.audioUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.audio),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(lesson.audioUrl!),
                        ],
                      ),
                      onTap: () async {
                        final uri = Uri.parse(lesson.audioUrl!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
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
                          loading: () => setState(() {
                            _isLoading = !_isLoading;
                          }),
                          loaded: () {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
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
                          orElse: () => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: PrimaryButton(
                              onPressed: () async => context
                                  .read<FinishLessonCubit>()
                                  .finishLesson(
                                    lessonUlid: lesson.ulid!,
                                    moduleUlid: moduleUlid,
                                    courseUlid: courseUlid,
                                  ),
                              title:
                                  _isLoading ? l10n.completing : l10n.complete,
                              disabled: _isLoading,
                              isLoading: _isLoading ? true : null,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
