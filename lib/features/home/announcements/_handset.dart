import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AnnouncementsPageHandset extends StatefulWidget {
  const AnnouncementsPageHandset({super.key});

  @override
  State<AnnouncementsPageHandset> createState() =>
      _AnnouncementsPageHandsetState();
}

class _AnnouncementsPageHandsetState extends State<AnnouncementsPageHandset> {
  @override
  void initState() {
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.landingRoute,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.announcements,
                        style: PRFText.theme()
                            .displayLarge
                            ?.copyWith(fontSize: 80.sp),
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
                  builder: (context, state) => state.maybeWhen(
                    orElse: () =>
                        const Center(child: LinearProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    loaded: (isEmpty) => isEmpty
                        ? Column(
                            children: [
                              const Icon(
                                Icons.timer,
                              ),
                              Center(
                                child: Text(
                                  l10n.noAnnouncements,
                                  style: PRFText.theme()
                                      .headlineMedium!
                                      .copyWith(
                                        color:
                                            AppTheme.appTheme().kDullGreyColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      l10n.pleaseWaitForOS,
                                      maxLines: 2,
                                      style: PRFText.theme()
                                          .displayLarge!
                                          .copyWith(
                                            color: AppTheme.appTheme()
                                                .kPrimaryColorV2,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
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
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverList.separated(
                    itemCount: groupedEntries!.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 48.h),
                    itemBuilder: (context, index) {
                      final mapAsList = groupedEntries.keys.toList();
                      final entries = groupedEntries[mapAsList[index]];

                      return Builder(
                        builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.w),
                                child: Text(
                                  DateFormat.yMMMMd().format(mapAsList[index]),
                                  style: PRFText.theme().bodyLarge?.copyWith(
                                        color:
                                            AppTheme.appTheme().kPrimaryColorV2,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 64.sp,
                                      ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: entries!.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 16.w),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: width,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50.w,
                                        vertical: 40.h,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.appTheme()
                                            .kSecondaryColorV2
                                            .withValues(alpha: 1),
                                        borderRadius:
                                            BorderRadius.circular(48.r),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          entries[index].title.toUpperCase(),
                                          style: PRFText.theme()
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppTheme.appTheme()
                                                    .kPrimaryColorV2,
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                        subtitle: Text(
                                          entries[index].content,
                                          style: PRFText.theme()
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.appTheme()
                                                    .kPrimaryColorV2,
                                              ),
                                        ),
                                        trailing: Text(
                                          Misc.formatTimeFromDateTime(
                                            entries[index].publishedAt,
                                          ),
                                          style: PRFText.theme()
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.appTheme()
                                                    .kPrimaryColorV2,
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
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
