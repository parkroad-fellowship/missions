import 'package:app/features/home/announcements/_shared.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
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
        final announcements = context
            .read<AnnouncementResourceCubit>()
            .currentItems;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.announcements,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _form.load(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: state.maybeWhen(
                          listLoading: (_) => announcements.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.lg,
                                  ),
                                  child: PRFLinearProgressIndicator(),
                                )
                              : const SizedBox.shrink(),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                      SliverFillRemaining(
                        child: state.maybeWhen(
                          listLoading: (_) => announcements.isEmpty
                              ? const Center(
                                  child: PRFCircularProgressIndicator(),
                                )
                              : const SizedBox.shrink(),
                          error: (message, _) => Align(
                            alignment: Alignment.topCenter,
                            child: PRFEmptyView(
                              label: l10n.noAnnouncements,
                              description: message,
                              icon: Icons.campaign_outlined,
                            ),
                          ),
                          listLoaded: (items, _, _) {
                            if (items.isEmpty) {
                              return PRFEmptyView(
                                label: l10n.noAnnouncements,
                                description: l10n.noAnnouncementsDesc,
                                icon: Icons.campaign_outlined,
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
                                final mapAsList = groupedEntries.keys.toList();
                                final entries =
                                    groupedEntries[mapAsList[index]]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          sidePanel: PRFBrandPanel(
            children: [
              PRFPanelSectionLabel(l10n.latestCampaign),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.announcementsPanelIntro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
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
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.campaign_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Text(
                      l10n.publicationsCount(announcements.length),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xxl),
              Center(
                child: Icon(
                  Icons.campaign_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.stayUpToDate,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.announcementsPanelBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
