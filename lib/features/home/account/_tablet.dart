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

class AccountPageTablet extends StatelessWidget {
  const AccountPageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<SignOutCubit, SignOutState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () => context.router.pushPath(
            PRFSuperAppRouter.decisionRoute,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Column - Details & Information (flex: 3)
                  Expanded(
                    flex: 3,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                              vertical: PRFSpacingTokens.lg,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () =>
                                      context.router.popUntilRouteWithPath(
                                        PRFSuperAppRouter.landingRoute,
                                      ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.xs),
                                Text(
                                  l10n.myAccount,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Personal Information Section
                        ValueListenableBuilder(
                          valueListenable: Hive.box<dynamic>(
                            PRFSuperAppConfig.instance!.values.hiveBox,
                          ).listenable(),
                          builder: (context, _, _) {
                            final profile = getIt<HiveService>().auth
                                .retrieveProfile();
                            if (profile == null) {
                              return const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              );
                            }
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: PRFSpacingTokens.md,
                                ),
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
                              ),
                            );
                          },
                        ),

                        // Memberships Section
                        ValueListenableBuilder(
                          valueListenable: Hive.box<dynamic>(
                            PRFSuperAppConfig.instance!.values.hiveBox,
                          ).listenable(),
                          builder: (context, _, _) {
                            final profile = getIt<HiveService>().auth
                                .retrieveProfile();
                            if (profile?.member?.memberships.isEmpty ?? true) {
                              return const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              );
                            }

                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: PRFSpacingTokens.md,
                                ),
                                child:
                                    buildMembershipsSection(
                                          context,
                                          theme,
                                          l10n,
                                          profile!,
                                        )
                                        .animate(
                                          delay: PRFMotionTokens.standard,
                                        )
                                        .fadeIn(duration: PRFMotionTokens.slow)
                                        .slideY(begin: 0.1, end: 0),
                              ),
                            );
                          },
                        ),

                        // Settings Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: PRFSpacingTokens.md,
                            ),
                            child: buildSettingsSection(context, theme, l10n)
                                .animate(delay: 250.ms)
                                .fadeIn(duration: PRFMotionTokens.slow)
                                .slideY(begin: 0.1, end: 0),
                          ),
                        ),

                        // Footer Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: PRFSpacingTokens.md,
                            ),
                            child: buildFooterSection(context, theme, l10n)
                                .animate(delay: PRFMotionTokens.slow)
                                .fadeIn(duration: PRFMotionTokens.slow)
                                .slideY(begin: 0.1, end: 0),
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: PRFSpacingTokens.xxl),
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                  ),

                  // Right Column - Profile Summary Sidebar & SignOut CTA (flex: 2)
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),

                          // Large profile card
                          buildProfileCard(context, theme, l10n),

                          const Spacer(),

                          // Beautiful centered logout button
                          PRFButton(
                            variant: PRFButtonVariant.destructive,
                            onPressed: () =>
                                context.read<SignOutCubit>().signOut(),
                            title: l10n.signOut,
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
