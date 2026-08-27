// ignore_for_file: avoid_positional_boolean_parameters
import 'package:app/features/lms/_shared.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:prf_design/prf_design.dart';

class LessonDetailsFormState {
  LessonDetailsFormState({required this.lessonModuleUlid});

  final String lessonModuleUlid;

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    final lessonCubit = context.read<LessonResourceCubit>();
    if (!lessonCubit.currentItems.any((l) => l.ulid == lessonModuleUlid)) {
      lessonCubit.loadAll();
    }
  }

  void dispose() {}
}

Widget buildLessonDetailsHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFLessonModule? lessonModule,
  int mediaCount,
  bool isCompleted,
  VoidCallback onBack,
) {
  final lesson = lessonModule?.lesson;

  return Container(
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
          onBack: onBack,
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
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class LessonContentCard extends StatelessWidget {
  const LessonContentCard({required this.lessonModule, super.key});

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
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: PRFOpacities.accent,
          ),
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

class LessonResourceTile extends StatelessWidget {
  const LessonResourceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    super.key,
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
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: PRFOpacities.accent,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
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

Widget buildLessonMedia({
  required BuildContext context,
  required PRFLessonModule lessonModule,
  required AppLocalizations l10n,
}) {
  final lesson = lessonModule.lesson;
  final resources = <Widget>[];

  if ((lesson?.videoUrl ?? '').trim().isNotEmpty) {
    resources.add(
      LessonResourceTile(
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
      LessonResourceTile(
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
      LessonResourceTile(
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
