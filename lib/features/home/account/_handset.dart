import 'package:app/enums/prf_membership_type.dart';
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

class AccountPageHandset extends StatelessWidget {
  const AccountPageHandset({super.key});

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
                          border: Border.all(width: 1.w),
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
                        l10n.myAccount,
                        style: Theme.of(context).textTheme.displayLarge,
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
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
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
                        child: FormFieldLabel(label: l10n.name),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: PRFNameInput(
                          hintText: l10n.enterName,
                          controller: TextEditingController(text: profile.name),

                          enabled: false,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: FormFieldLabel(label: l10n.email),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: PRFNameInput(
                          hintText: l10n.enterEmail,
                          controller: TextEditingController(
                            text: profile.email,
                          ),

                          enabled: false,
                        ),
                      ),
                    ]),
                  );
                },
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

                  if (profile.member == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  if (profile.member!.memberships == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(top: 64.w),
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        l10n.memberships,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  );
                },
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

                  if (profile.member == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  if (profile.member!.memberships == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverList.builder(
                    itemCount: profile.member!.memberships!.length,
                    itemBuilder:
                        (context, index) => ListTile(
                          title: Text(
                            profile
                                .member!
                                .memberships![index]
                                .spiritualYear!
                                .name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          subtitle: Text(
                            PrfMembershipType.fromIndex(
                              profile.member!.memberships![index].type,
                            ).name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Icon(
                            profile.member!.memberships![index].approved
                                ? Icons.check_outlined
                                : Icons.pending_actions,
                          ),
                        ),
                  );
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
              SliverToBoxAdapter(
                child: Align(
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
                        style: Theme.of(context).textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: l10n.terms,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
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
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          TextSpan(
                            text: l10n.privacyPolicy,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
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
              ),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    l10n.version(Misc.getAppVersion()),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
