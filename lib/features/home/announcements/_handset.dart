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
                  onRefresh: () => context
                      .read<GetAnnouncementsCubit>()
                      .getAnnouncements(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
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
                                color: colorScheme.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              DateFormat.yMMMMd().format(mapAsList[index]),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Announcements for this date
                          ...entries.map((announcement) => 
                            _CleanAnnouncementCard(
                              announcement: announcement,
                              timezone: timezone,
                            ),
                          ),

                          const SizedBox(height: 24),
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

class _CleanAnnouncementCard extends StatelessWidget {
  final PRFLocalAnnouncement announcement;
  final String timezone;

  const _CleanAnnouncementCard({
    required this.announcement,
    required this.timezone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
          padding: const EdgeInsets.all(16),
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
                      size: 16,
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
              
              const SizedBox(height: 12),
              
              // Content with proper spacing
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: HtmlWidget(
                  announcement.content,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // // Tap hint similar to your button style
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Text(
              //     'Tap for details',
              //     style: textTheme.labelSmall?.copyWith(
              //       color: colorScheme.primary,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
