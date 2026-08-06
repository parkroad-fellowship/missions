import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:prf_design/prf_design.dart';

class AnnouncementsFormState {
  AnnouncementsFormState();

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    context.read<AnnouncementResourceCubit>().loadAll();
  }

  void dispose() {}

  Map<DateTime, List<PRFAnnouncement>> groupByDate(
    List<PRFAnnouncement> announcements,
  ) {
    final grouped = <DateTime, List<PRFAnnouncement>>{};
    for (final a in announcements) {
      final dateKey = DateTime(
        a.publishedAt.year,
        a.publishedAt.month,
        a.publishedAt.day,
      );
      grouped.putIfAbsent(dateKey, () => []).add(a);
    }
    return grouped;
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    required this.announcement,
    required this.timezone,
    super.key,
  });

  final PRFAnnouncement announcement;
  final String timezone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final previewText = announcement.content
        .replaceAll(RegExp('<[^>]*>'), '')
        .trim();
    final truncatedPreview = previewText.length > 180
        ? '${previewText.substring(0, 180)}...'
        : previewText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.sm),
      child: PRFDetailActionCard(
        margin: EdgeInsets.zero,
        onTap: () => PRFBottomSheet.show<dynamic>(
          context,
          title: announcement.title,
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                      ),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.lg),
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.xl),
                HtmlWidget(
                  announcement.content,
                  textStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.campaign_rounded,
            size: 22,
            color: colorScheme.onPrimary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: colorScheme.primary,
        ),
        title: announcement.title,
        subtitle: truncatedPreview,
        footer: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: PRFSpacingTokens.xs),
            Text(
              DateFormatter.formatTimeFromDateTime(
                announcement.publishedAt,
                timezone,
              ),
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
