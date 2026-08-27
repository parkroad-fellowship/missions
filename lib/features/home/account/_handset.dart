import 'package:app/di/di_container.dart';
import 'package:app/features/home/account/_shared.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:prf_design/prf_design.dart';

class AccountPageHandset extends StatelessWidget {
  const AccountPageHandset({super.key});

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
              title: l10n.myAccount,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              actions: [
                Animate(
                  effects: [ShimmerEffect(duration: 1.seconds)],
                  child: BlocListener<SignOutCubit, SignOutState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        loaded: () => context.router.pushPath(
                          PRFSuperAppRouter.decisionRoute,
                        ),
                        orElse: () {},
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(
                          alpha: PRFOpacities.subtle,
                        ),
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.smd,
                        ),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(
                            alpha: PRFOpacities.glow,
                          ),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => context.read<SignOutCubit>().signOut(),
                        icon: Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        tooltip: l10n.signOut,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xl),
                ),

                // Profile Section
                SliverToBoxAdapter(
                  child: buildProfileCard(context, theme, l10n)
                      .animate()
                      .fadeIn(duration: PRFMotionTokens.slow)
                      .slideY(begin: 0.1, end: 0),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xl),
                ),

                // Personal Information Section
                ValueListenableBuilder(
                  valueListenable: Hive.box<dynamic>(
                    PRFSuperAppConfig.instance!.values.hiveBox,
                  ).listenable(),
                  builder: (context, _, _) {
                    final profile = getIt<HiveService>().auth.retrieveProfile();
                    if (profile == null) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child:
                          buildPersonalInfoSection(
                                context,
                                theme,
                                l10n,
                                profile,
                              )
                              .animate(delay: 100.ms)
                              .fadeIn(duration: PRFMotionTokens.slow)
                              .slideY(begin: 0.1, end: 0),
                    );
                  },
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xl),
                ),

                // Memberships Section
                ValueListenableBuilder(
                  valueListenable: Hive.box<dynamic>(
                    PRFSuperAppConfig.instance!.values.hiveBox,
                  ).listenable(),
                  builder: (context, _, _) {
                    final profile = getIt<HiveService>().auth.retrieveProfile();
                    if (profile?.member?.memberships.isEmpty ?? true) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }

                    return SliverToBoxAdapter(
                      child:
                          buildMembershipsSection(
                                context,
                                theme,
                                l10n,
                                profile!,
                              )
                              .animate(delay: PRFMotionTokens.standard)
                              .fadeIn(duration: PRFMotionTokens.slow)
                              .slideY(begin: 0.1, end: 0),
                    );
                  },
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xl),
                ),

                // Settings Section
                SliverToBoxAdapter(
                  child: buildSettingsSection(context, theme, l10n)
                      .animate(delay: 250.ms)
                      .fadeIn(duration: PRFMotionTokens.slow)
                      .slideY(begin: 0.1, end: 0),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xxl),
                ),

                // Footer Section
                SliverToBoxAdapter(
                  child: buildFooterSection(context, theme, l10n)
                      .animate(delay: PRFMotionTokens.slow)
                      .fadeIn(duration: PRFMotionTokens.slow)
                      .slideY(begin: 0.1, end: 0),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: PRFSpacingTokens.xxl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
