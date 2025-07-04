import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class AnnouncementsPageTablet extends StatefulWidget {
  const AnnouncementsPageTablet({super.key});

  @override
  State<AnnouncementsPageTablet> createState() =>
      _AnnouncementsPageTabletState();
}

class _AnnouncementsPageTabletState extends State<AnnouncementsPageTablet>
    with TimezoneMixin {
  @override
  void initState() {
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.announcements),
      ),
      body: Column(
        children: [
          // Loading Indicator using your custom widget
          BlocBuilder<GetAnnouncementsCubit, GetAnnouncementsState>(
            builder: (context, state) => state.maybeWhen(
              loading: () => const PRFLinearProgressIndicator(),
              orElse: () => const SizedBox.shrink(),
            ),
          ),

          // Content
          Expanded(
            child: StreamBuilder<Map<DateTime, List<PRFLocalAnnouncement>>>(
              stream: getIt<LocalDBService>().getAnnouncements(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const PRFCircularProgressIndicator();
                }

                final groupedEntries = snapshot.data;

                if (groupedEntries == null || groupedEntries.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetAnnouncementsCubit>()
                        .getAnnouncements(),
                    child: PRFEmptyView(
                      label: l10n.noAnnouncements,
                      description: l10n.pleaseWaitForOS,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<GetAnnouncementsCubit>().getAnnouncements(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: groupedEntries.length,
                    itemBuilder: (context, index) {
                      final mapAsList = groupedEntries.keys.toList();
                      final entries = groupedEntries[mapAsList[index]]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header with better styling
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              DateFormat.yMMMMd().format(mapAsList[index]),
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Announcements for this date in grid layout for tablet
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.5,
                                ),
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              final announcement = entries[index];
                              return _TabletAnnouncementCard(
                                announcement: announcement,
                                timezone: timezone,
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletAnnouncementCard extends StatelessWidget {
  final PRFLocalAnnouncement announcement;
  final String timezone;

  const _TabletAnnouncementCard({
    required this.announcement,
    required this.timezone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Add navigation or detail view here
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with announcement icon and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Announcement icon similar to your empty state
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.campaign_outlined,
                      size: 18,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      announcement.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Time badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Misc.formatTimeFromDateTime(
                        announcement.publishedAt,
                        timezone,
                      ),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Content with proper spacing and overflow handling
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: HtmlWidget(
                    announcement.content,
                    textStyle: textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom indicator
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Tap for details',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
