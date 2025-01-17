import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentAccountPageHandset extends StatelessWidget {
  const StudentAccountPageHandset({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Row(
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
                          PRFSuperAppRouter.studentLandingRoute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.myAccount,
                      style: CustomTextTheme.customTextTheme()
                          .displayLarge
                          ?.copyWith(fontSize: 80.sp),
                    ),
                    const Spacer(),
                    Animate(
                      effects: [
                        ShimmerEffect(
                          duration: 1.seconds,
                        ),
                      ],
                      child: BlocListener<SignOutCubit, SignOutState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            orElse: () => context.router.pushNamed(
                              PRFSuperAppRouter.decisionRoute,
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () => context.read<SignOutCubit>().signOut(),
                          child: Padding(
                            padding: EdgeInsets.only(right: 17.w),
                            child: Center(
                              child: Text(
                                l10n.signOut,
                                style: CustomTextTheme.customTextTheme()
                                    .headlineMedium!
                                    .copyWith(
                                      color: AppTheme.appTheme().kRedColor,
                                      fontSize: 54.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<dynamic>(
                PRFSuperAppConfig.instance!.values.hiveBox,
              ).listenable(),
              builder: (context, box, _) {
                final profile = getIt<HiveService>().retrieveProfile();
                if (profile == null) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 64.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: FormFieldLabel(
                          label: l10n.name,
                          color: AppTheme.appTheme().kBlackColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: InputFormField(
                          hintText: l10n.enterName,
                          controller: TextEditingController(text: profile.name),
                          isUnderLine: true,
                          enabled: false,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: FormFieldLabel(
                          label: l10n.email,
                          color: AppTheme.appTheme().kBlackColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: InputFormField(
                          hintText: l10n.enterEmail,
                          controller:
                              TextEditingController(text: profile.email),
                          isUnderLine: true,
                          isEmail: true,
                          enabled: false,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 20,
                            top: 30,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: l10n.byUsing,
                              style: CustomTextTheme.customTextTheme()
                                  .displaySmall!
                                  .copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF727272),
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                              children: [
                                TextSpan(
                                  text: l10n.terms,
                                  style: CustomTextTheme.customTextTheme()
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            AppTheme.appTheme().kPrimaryColorV2,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final uri = Uri(
                                        scheme: 'https',
                                        host: 'parkroadfellowship.org',
                                        path: '/privacy-policy',
                                      );
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: l10n.and,
                                  style: CustomTextTheme.customTextTheme()
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppTheme.appTheme().kBlackColor,
                                      ),
                                ),
                                TextSpan(
                                  text: l10n.privacyPolicy,
                                  style: CustomTextTheme.customTextTheme()
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            AppTheme.appTheme().kPrimaryColorV2,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final uri = Uri(
                                        scheme: 'https',
                                        host: 'parkroadfellowship.org',
                                        path: 'privacy-policy',
                                      );
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          l10n.version(Misc.getAppVersion()),
                          style: CustomTextTheme.customTextTheme()
                              .displaySmall!
                              .copyWith(
                                fontSize: 12,
                                color: const Color(0xFF727272),
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
