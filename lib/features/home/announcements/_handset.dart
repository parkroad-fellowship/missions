import 'package:app/features/home/shared/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(title: l10n.announcements),
            SliverToBoxAdapter(
              child: BlocBuilder<GetAnnouncementsCubit, GetAnnouncementsState>(
                builder: (context, state) => state.maybeWhen(
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: PRFSpacingTokens.lg),
                    child: PRFLinearProgressIndicator(),
                  ),
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
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      itemCount: groupedEntries.length,
                      itemBuilder: (context, index) {
                        final mapAsList = groupedEntries.keys.toList();
                        final entries = groupedEntries[mapAsList[index]]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Header with your theme
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: PRFSpacingTokens.lg,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: PRFSpacingTokens.lg,
                                vertical: PRFSpacingTokens.sm,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.smd,
                                ),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  ),
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
                            ...entries.map(
                              (announcement) => _AnnouncementCard(
                                announcement: announcement,
                                timezone: timezone,
                              ),
                            ),

                            const SizedBox(height: PRFSpacingTokens.xl),
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

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
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
      margin: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.10),
        ),
      ),
      child: GestureDetector(
        onTap: () => WoltModalSheet.show<dynamic>(
          context: context,
          pageListBuilder: (modalSheetContext) => [
            WoltModalSheetPage(
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
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
                            style: textTheme.titleMedium?.copyWith(
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
                      textStyle: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.xl,
            PRFSpacingTokens.xl,
            PRFSpacingTokens.xl,
            PRFSpacingTokens.lg,
          ),
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
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
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
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Row(
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
              const SizedBox(height: PRFSpacingTokens.lg),
              Text(
                announcement.content * 25,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
