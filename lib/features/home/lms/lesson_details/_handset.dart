import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonDetailsHandset extends StatefulWidget {
  const LessonDetailsHandset({
    required this.lesson,
    super.key,
  });

  final PRFLocalLesson lesson;

  @override
  State<LessonDetailsHandset> createState() => _LessonDetailsHandsetState();
}

class _LessonDetailsHandsetState extends State<LessonDetailsHandset> {
  PRFLocalLesson get lesson => widget.lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.lessonDetails,
          style: CustomTextTheme.customTextTheme()
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(lesson.name!.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.description),
                  Text(lesson.description!),
                ],
              ),
            ),

            // Lesson content
            if (lesson.content != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.content),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(lesson.content!),
                  ],
                ),
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
          ],
        ),
      ),
    );
  }
}
