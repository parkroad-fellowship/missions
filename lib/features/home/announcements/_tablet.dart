import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AnnouncementsPageTablet extends StatefulWidget {
  const AnnouncementsPageTablet({super.key});

  @override
  State<AnnouncementsPageTablet> createState() =>
      _AnnouncementsPageTabletState();
}

class _AnnouncementsPageTabletState extends State<AnnouncementsPageTablet> {
  String get timezone => getIt<HiveService>().timezone;
  @override
  void initState() {
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              const SliverToBoxAdapter(child: SizedBox(height: 36)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.w,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.landingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.announcements,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child:
                    BlocBuilder<GetAnnouncementsCubit, GetAnnouncementsState>(
                      builder:
                          (context, state) => state.maybeWhen(
                            loading:
                                () => const Center(
                                  child: LinearProgressIndicator(),
                                ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                    ),
              ),
              StreamBuilder<Map<DateTime, List<PRFLocalAnnouncement>>>(
                stream: getIt<LocalDBService>().getAnnouncements(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final groupedEntries = snapshot.data;

                  if (groupedEntries != null && groupedEntries.isEmpty) {
                    return SliverFillRemaining(
                      child: RefreshIndicator(
                        onRefresh:
                            () =>
                                context
                                    .read<GetAnnouncementsCubit>()
                                    .getAnnouncements(),
                        child: PRFEmptyView(
                          label: l10n.noAnnouncements,
                          description: l10n.pleaseWaitForOS,
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: groupedEntries!.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: 48.h),
                    itemBuilder: (context, index) {
                      final mapAsList = groupedEntries.keys.toList();
                      final entries = groupedEntries[mapAsList[index]];

                      return Builder(
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.yMMMMd().format(mapAsList[index]),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 16.h),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: entries!.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          SizedBox(height: 16.w),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: width,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40.w,
                                          vertical: 32.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            48.r,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withValues(alpha: .4),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            entries[index].title.toUpperCase(),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                          ),
                                          subtitle: Text(
                                            entries[index].content,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                          trailing: Text(
                                            Misc.formatTimeFromDateTime(
                                              entries[index].publishedAt,
                                              timezone,
                                            ),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
