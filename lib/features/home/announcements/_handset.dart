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

class AnnouncementsPageHandset extends StatefulWidget {
  const AnnouncementsPageHandset({super.key});

  @override
  State<AnnouncementsPageHandset> createState() =>
      _AnnouncementsPageHandsetState();
}

class _AnnouncementsPageHandsetState extends State<AnnouncementsPageHandset>
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
                                  onRefresh: () async => _form.load(context),
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

                              final groupedEntries = _form.groupByDate(
                                announcements,
                              );

                              return RefreshIndicator(
                                onRefresh: () async => _form.load(context),
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
