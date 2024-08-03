import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LandingPageHandset extends StatefulWidget {
  const LandingPageHandset({super.key});

  @override
  State<LandingPageHandset> createState() => _LandingPageHandsetState();
}

class _LandingPageHandsetState extends State<LandingPageHandset> {
  @override
  void initState() {
    context.read<GetClassGroupsCubit>().getClassGroups();
    context.read<GetAnnouncementsCubit>().getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.accountRoute,
                        ),
                        child: CircleAvatar(
                          radius: 70.r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            child: Text(
                              Misc.getUserNameInitials(
                                getIt<HiveService>().retrieveProfile()!.name,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 32.w),
                      Text(
                        l10n.hello(
                          getIt<HiveService>()
                              .retrieveProfile()!
                              .member!
                              .lastName,
                        ),
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 60.sp),
                      ),
                      const Spacer(),
                      Animate(
                        effects: [
                          ShimmerEffect(
                            duration: 1.seconds,
                          ),
                          const ShakeEffect(),
                        ],
                        child: GestureDetector(
                          onTap: () => context.router
                              .pushNamed(PRFSuperAppRouter.announcementsRoute),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.appTheme().kPrimaryColorV2,
                                width: 1.w,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 70.r,
                              backgroundColor: Colors.transparent,
                              child: const Badge(
                                child: Icon(
                                  Icons.notifications_none,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w) +
                      EdgeInsets.only(bottom: 80.h),
                  child: Text(
                    l10n.iWantTo,
                    style: CustomTextTheme.customTextTheme()
                        .displayLarge
                        ?.copyWith(
                          color: AppTheme.appTheme().kPrimaryColorV2,
                          fontWeight: FontWeight.w600,
                          fontSize: 88.sp,
                        ),
                  ),
                ),
                SizedBox(height: 16.h),
                Animate(
                  effects: [
                    MoveEffect(
                      duration: .5.seconds,
                      curve: Curves.easeOutQuad,
                      begin: const Offset(-160, 0),
                    ),
                  ],
                  child: HomeActionCard(
                    title: l10n.goToAMission,
                    assetPath: 'assets/svgs/missions.svg',
                    onTap: () => context.router
                        .pushNamed(PRFSuperAppRouter.missionsRoute),
                  ),
                ),
                SizedBox(height: 32.h),
                Animate(
                  effects: [
                    MoveEffect(
                      duration: .5.seconds,
                      curve: Curves.easeOutQuad,
                      begin: const Offset(160, 0),
                    ),
                  ],
                  child: HomeActionCard(
                    title: l10n.learnSomething,
                    assetPath: 'assets/svgs/lms.svg',
                    onTap: () =>
                        context.router.pushNamed(PRFSuperAppRouter.lmsRoute),
                  ),
                ),
                SizedBox(height: 32.h),
                Animate(
                  effects: [
                    MoveEffect(
                      duration: .5.seconds,
                      curve: Curves.easeOutQuad,
                      begin: const Offset(-160, 0),
                    ),
                  ],
                  child: HomeActionCard(
                    title: l10n.ministerToAStudent,
                    assetPath: 'assets/svgs/student_ministry.svg',
                    onTap: () => context.router
                        .pushNamed(PRFSuperAppRouter.studentEnquiriesRoute),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    required this.title,
    required this.assetPath,
    this.onTap,
    super.key,
  });

  final String title;
  final String assetPath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 100.w,
              vertical: 80.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppTheme.appTheme().kSecondaryColorV2.withOpacity(1),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  assetPath,
                  height: 250.h,
                ),
                SizedBox(height: 100.h),
                Text(
                  title,
                  style:
                      CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: SizedBox(
                height: 225.h,
                width: 210.w,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 140.r,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.appTheme().kPrimaryColorV2,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 230.w,
                  height: 230.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 400.dg,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
