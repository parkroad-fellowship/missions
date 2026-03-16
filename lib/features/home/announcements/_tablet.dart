import 'package:app/features/home/shared/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            PRFNavBar(title: l10n.announcements),
            SliverToBoxAdapter(
              child: BlocBuilder<GetAnnouncementsCubit, GetAnnouncementsState>(
                builder: (context, state) => state.maybeWhen(
                  loading: () => const PRFLinearProgressIndicator(),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
            ),
            SliverFillRemaining(
              child: StreamBuilder<Map<DateTime, List<PRFLocalAnnouncement>>>(
                stream: getIt<IsarService>().announcements
                    .getAnnouncementsGrouped(),
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

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetAnnouncementsCubit>()
                        .getAnnouncements(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                      itemCount: groupedEntries.length,
                      itemBuilder: (context, index) {
                        final mapAsList = groupedEntries.keys.toList();
                        final entries = groupedEntries[mapAsList[index]]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Header with enhanced styling
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.xl),
                              padding: const EdgeInsets.symmetric(
                                horizontal: PRFSpacingTokens.xl,
                                vertical: PRFSpacingTokens.md,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  ),
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

                            // Announcements for this date in grid layout
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  // ignore: lines_longer_than_80_chars
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 1.3,
                                  ),
                              itemCount: entries.length,
                              itemBuilder: (context, announcementIndex) {
                                final announcement = entries[announcementIndex];
                                return _TabletAnnouncementCard(
                                      announcement: announcement,
                                      timezone: timezone,
                                    )
                                    .animate(
                                      delay: (announcementIndex * 100).ms,
                                    )
                                    .fadeIn(duration: PRFMotionTokens.slow)
                                    .slideY(begin: 0.1, end: 0);
                              },
                            ),

                            const SizedBox(height: PRFSpacingTokens.xxl),
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
      ),
    );
  }
}

class _TabletAnnouncementCard extends StatelessWidget {
  const _TabletAnnouncementCard({
    required this.announcement,
    required this.timezone,
  });
  final PRFLocalAnnouncement announcement;
  final String timezone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => WoltModalSheet.show<dynamic>(
            context: context,
            pageListBuilder: (modalSheetContext) => [
              WoltModalSheetPage(
                backgroundColor: colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(PRFSpacingTokens.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                            ),
                            child: Icon(
                              Icons.campaign_rounded,
                              color: colorScheme.onPrimary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: PRFSpacingTokens.xl),
                          Expanded(
                            child: Text(
                              announcement.title,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: PRFSpacingTokens.xxl),
                      HtmlWidget(
                        announcement.content,
                        textStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with icon, title, and time
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(PRFSpacingTokens.md),
                      child: Icon(
                        Icons.campaign_rounded,
                        size: 24,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: PRFSpacingTokens.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.xs),
                              Text(
                                DateFormatter.formatTimeFromDateTime(
                                  announcement.publishedAt,
                                  timezone,
                                ),
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.xl),
                Expanded(
                  child: Text(
                    announcement.content.replaceAll(RegExp('<[^>]*>'), ''),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                // Bottom action indicator
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.md,
                        vertical: PRFSpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tap for details',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: PRFSpacingTokens.xs),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
