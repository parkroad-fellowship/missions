import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/home_action_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentLandingPageHandset extends StatefulWidget {
  const StudentLandingPageHandset({super.key});

  @override
  State<StudentLandingPageHandset> createState() =>
      _StudentLandingPageHandsetState();
}

class _StudentLandingPageHandsetState extends State<StudentLandingPageHandset> {
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
                SizedBox(height: 88.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.router.pushNamed(
                          PRFSuperAppRouter.studentAccountRoute,
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
                          getIt<HiveService>().retrieveProfile()!.student!.name,
                        ),
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 60.sp),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 200.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w) +
                      EdgeInsets.only(bottom: 80.h),
                  child: Text(
                    l10n.lookingFor,
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
                    title: l10n.faqs,
                    assetPath: 'assets/svgs/missions.svg',
                    onTap: () =>
                        context.router.pushNamed(PRFSuperAppRouter.learnerFaqs),
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
                    title: l10n.askQuestion,
                    assetPath: 'assets/svgs/lms.svg',
                    onTap: () => context.router
                        .pushNamed(PRFSuperAppRouter.learnerEnquiriesRoute),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
