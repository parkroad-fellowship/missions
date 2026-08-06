import 'package:app/features/home/announcements/_shared.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class AnnouncementsPageTablet extends StatefulWidget {
  const AnnouncementsPageTablet({super.key});

  @override
  State<AnnouncementsPageTablet> createState() =>
      _AnnouncementsPageTabletState();
}

class _AnnouncementsPageTabletState extends State<AnnouncementsPageTablet>
    with TimezoneMixin {
  final _form = AnnouncementsFormState();

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<
      AnnouncementResourceCubit,
      ResourceState<PRFAnnouncement>
    >(
      builder: (context, state) {
        final announcements = state.maybeWhen(
          listLoaded: (values, _, _) => values,
          orElse: List<PRFAnnouncement>.empty,
        );

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Announcements List (flex: 3)
                    Expanded(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: () async => _form.load(context),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                  vertical: PRFSpacingTokens.lg,
                                ),
                                child: Text(
                                  l10n.announcements,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: state.maybeWhen(
                                listLoading: (_) => const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.lg,
                                  ),
                                  child: PRFLinearProgressIndicator(),
                                ),
                                orElse: () => const SizedBox.shrink(),
                              ),
                            ),
                            SliverFillRemaining(
                              child: state.maybeWhen(
                                listLoading: (_) => const Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                                error: (message, _) =>
                                    Center(child: Text(message)),
                                listLoaded: (items, _, _) {
                                  if (items.isEmpty) {
                                    return PRFEmptyView(
                                      label: l10n.noAnnouncements,
                                      description: l10n.pleaseWaitForOS,
                                    );
                                  }

                                  final groupedEntries = _form.groupByDate(
                                    items,
                                  );

                                  return ListView.builder(
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
                                          ...entries.map(
                                            (announcement) => AnnouncementCard(
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
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Announcement Info & Sidebar Guidance (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latest Campaign',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Stats or Total count Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.md,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Announcements and publications received recently from the Fellowship admin.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PRFSpacingTokens.md,
                                      vertical: PRFSpacingTokens.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.lg,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.campaign_outlined,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: PRFSpacingTokens.sm,
                                        ),
                                        Text(
                                          '${announcements.length} Publications',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Helpful guidance card
                            Center(
                              child: Icon(
                                Icons.campaign_rounded,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Stay Up to Date',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Keep track of important announcements, spiritual years publications, events alerts, and news directly shared by Park Road Fellowship.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
