import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class AnnouncementsPageHandset extends StatefulWidget {
  const AnnouncementsPageHandset({super.key});

  @override
  State<AnnouncementsPageHandset> createState() =>
      _AnnouncementsPageHandsetState();
}

class _AnnouncementsPageHandsetState extends State<AnnouncementsPageHandset>
    with TimezoneMixin {
  @override
  void initState() {
    context.read<AnnouncementResourceCubit>().loadAll();
    super.initState();
  }

  Map<DateTime, List<PRFAnnouncement>> _groupByDate(
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          ColoredBox(
            color: theme.colorScheme.primary,
            child: PRFBrandedNavBar(
              title: l10n.announcements,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child:
                      BlocBuilder<
                        AnnouncementResourceCubit,
                        ResourceState<PRFAnnouncement>
                      >(
                        builder: (context, state) => state.maybeWhen(
                          listLoading: (_) => const Padding(
                            padding: EdgeInsets.only(
                              bottom: PRFSpacingTokens.lg,
                            ),
                            child: PRFLinearProgressIndicator(),
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                ),
                SliverFillRemaining(
                  child:
                      BlocBuilder<
                        AnnouncementResourceCubit,
                        ResourceState<PRFAnnouncement>
                      >(
                        builder: (context, state) {
                          return state.maybeWhen(
                            listLoading: (_) =>
                                const PRFCircularProgressIndicator(),
                            error: (message, _) => Center(child: Text(message)),
                            listLoaded: (announcements, _, _) {
                              if (announcements.isEmpty) {
                                return RefreshIndicator(
                                  onRefresh: () => context
                                      .read<AnnouncementResourceCubit>()
                                      .loadAll(),
                                  child: ListView(
                                    children: [
                                      PRFEmptyView(
                                        label: l10n.noAnnouncements,
                                        description: l10n.pleaseWaitForOS,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final groupedEntries = _groupByDate(
                                announcements,
                              );

                              return RefreshIndicator(
                                onRefresh: () => context
                                    .read<AnnouncementResourceCubit>()
                                    .loadAll(),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.lg,
                                  ),
                                  itemCount: groupedEntries.length,
                                  itemBuilder: (context, index) {
                                    final mapAsList = groupedEntries.keys
                                        .toList();
                                    final entries =
                                        groupedEntries[mapAsList[index]]!;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PRFSectionHeader(
                                          title: DateFormat.yMMMMd().format(
                                            mapAsList[index],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: PRFSpacingTokens.lg,
                                          ),
                                        ),

                                        // Announcements for this date
                                        ...entries.map(
                                          (announcement) => _AnnouncementCard(
                                            announcement: announcement,
                                            timezone: timezone,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: PRFSpacingTokens.xl,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.timezone,
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
