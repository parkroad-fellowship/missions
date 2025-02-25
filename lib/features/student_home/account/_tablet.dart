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

class StudentAccountPageTablet extends StatelessWidget {
  const StudentAccountPageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
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
                            color: PRFApp.theme().kPrimaryColorV2,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.studentLandingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.myAccount,
                        style: PRFText.theme().displayLarge?.copyWith(
                          fontSize: 56.sp,
                        ),
                      ),
                      const Spacer(),
                      Animate(
                        effects: [ShimmerEffect(duration: 1.seconds)],
                        child: BlocListener<SignOutCubit, SignOutState>(
                          listener: (context, state) {
                            state.maybeWhen(
                              orElse:
                                  () => context.router.pushNamed(
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
                                  style: PRFText.theme().headlineMedium!
                                      .copyWith(
                                        color: PRFApp.theme().kRedColor,
                                        fontSize: 40.sp,
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
                valueListenable:
                    Hive.box<dynamic>(
                      PRFSuperAppConfig.instance!.values.hiveBox,
                    ).listenable(),
                builder: (context, box, _) {
                  final profile = getIt<HiveService>().retrieveProfile();
                  if (profile == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 64.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: FormFieldLabel(
                          label: l10n.name,
                          color: PRFApp.theme().kBlackColor,
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
                          color: PRFApp.theme().kBlackColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: InputFormField(
                          hintText: l10n.enterEmail,
                          controller: TextEditingController(
                            text: profile.email,
                          ),
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
                              style: PRFText.theme().displaySmall!.copyWith(
                                fontSize: 12,
                                color: const Color(0xFF727272),
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: l10n.terms,
                                  style: PRFText.theme().displaySmall!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: PRFApp.theme().kPrimaryColorV2,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () async {
                                          final uri = Uri(
                                            scheme: 'https',
                                            host: 'parkroadfellowship.org',
                                            path: '/privacy-policy',
                                          );
                                          await Misc.openUrl(uri);
                                        },
                                ),
                                TextSpan(
                                  text: l10n.and,
                                  style: PRFText.theme().displaySmall!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: PRFApp.theme().kBlackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: l10n.privacyPolicy,
                                  style: PRFText.theme().displaySmall!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: PRFApp.theme().kPrimaryColorV2,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () async {
                                          final uri = Uri(
                                            scheme: 'https',
                                            host: 'parkroadfellowship.org',
                                            path: 'privacy-policy',
                                          );
                                          await Misc.openUrl(uri);
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
                          style: PRFText.theme().displaySmall!.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF727272),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]),
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
