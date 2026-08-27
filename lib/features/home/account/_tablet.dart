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

class AccountPageTablet extends StatefulWidget {
  const AccountPageTablet({super.key});

  @override
  State<AccountPageTablet> createState() => _AccountPageTabletState();
}

class _AccountPageTabletState extends State<AccountPageTablet> {
  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

    return BlocListener<SignOutCubit, SignOutState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: () => context.router.pushPath(
            PRFSuperAppRouter.decisionRoute,
          ),
          orElse: () {},
        );
      },
      child: PRFTabletSplitScaffold(
        content: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PRFTabletHeaderRow(
                title: l10n.myAccount,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
            ),

            // Personal Information Section
            SliverToBoxAdapter(
              child: _EntranceSection(
                animate: animateEntrance,
                delay: Duration.zero,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<dynamic>(
                    PRFSuperAppConfig.instance!.values.hiveBox,
                  ).listenable(),
                  builder: (context, _, _) {
                    final profile = getIt<HiveService>().auth.retrieveProfile();
                    if (profile == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: PRFSpacingTokens.md,
                      ),
                      child: buildPersonalInfoSection(
                        context,
                        theme,
                        l10n,
                        profile,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Memberships Section
            SliverToBoxAdapter(
              child: _EntranceSection(
                animate: animateEntrance,
                delay: PRFMotionTokens.standard,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<dynamic>(
                    PRFSuperAppConfig.instance!.values.hiveBox,
                  ).listenable(),
                  builder: (context, _, _) {
                    final profile = getIt<HiveService>().auth.retrieveProfile();
                    if (profile?.member?.memberships.isEmpty ?? true) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: PRFSpacingTokens.md,
                      ),
                      child: buildMembershipsSection(
                        context,
                        theme,
                        l10n,
                        profile!,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Settings Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: PRFSpacingTokens.md,
                ),
                child: _EntranceSection(
                  animate: animateEntrance,
                  delay: PRFMotionTokens.enterShort * 2,
                  child: buildSettingsSection(context, theme, l10n),
                ),
              ),
            ),

            // Footer Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: PRFSpacingTokens.md,
                ),
                child: _EntranceSection(
                  animate: animateEntrance,
                  delay: PRFMotionTokens.slow,
                  child: buildFooterSection(context, theme, l10n),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xxl),
            ),
          ],
        ),
        sidePanel: PRFBrandPanel(
          children: [
            const SizedBox(height: PRFSpacingTokens.xxxl),

            // Large profile card
            Center(child: buildProfileCard(context, theme, l10n)),

            const SizedBox(height: PRFSpacingTokens.xxl),

            // Destructive sign-out action
            PRFButton(
              variant: PRFButtonVariant.destructive,
              onPressed: () => context.read<SignOutCubit>().signOut(),
              title: l10n.signOut,
            ),
          ],
        ),
      ),
    );
  }
}

/// Plays a one-time entrance cascade per screen instance; later rebuilds
/// (e.g. Hive writes) render instantly.
class _EntranceSection extends StatelessWidget {
  const _EntranceSection({
    required this.animate,
    required this.delay,
    required this.child,
  });

  final bool animate;
  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animate || MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return child
        .animate(delay: delay)
        .fadeIn(duration: PRFMotionTokens.slow)
        .slideY(begin: 0.1, end: 0);
  }
}
