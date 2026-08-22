import 'package:app/features/home/prayer_requests/_shared.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class PrayerRequestTablet extends StatefulWidget {
  const PrayerRequestTablet({super.key});

  @override
  State<PrayerRequestTablet> createState() => _PrayerRequestTabletState();
}

class _PrayerRequestTabletState extends State<PrayerRequestTablet> {
  final _form = PrayerRequestsFormState();

  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<
      PrayerRequestResourceCubit,
      ResourceState<PRFPrayerRequest>
    >(
      builder: (context, state) {
        final prayerRequests = context
            .read<PrayerRequestResourceCubit>()
            .currentItems;

        // The entrance cascade plays exactly once per screen instance;
        // later rebuilds (refresh setState) and scrolled-in cards skip it.
        final animateEntrance = !_entrancePlayed;
        _entrancePlayed = true;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.prayerRequests,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => _form.load(context),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _form.load(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) =>
                              prayerRequests.isEmpty
                              ? const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: PRFCircularProgressIndicator(),
                                  ),
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
                                ),
                          error: (message, _) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: PRFEmptyView(
                                label: l10n.noPrayerRequests,
                                description: message,
                                icon: Icons.hail_rounded,
                              ),
                            ),
                          ),
                          listLoaded: (requests, _, _) {
                            if (requests.isEmpty) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.noPrayerRequests,
                                    description:
                                        l10n.noPrayerRequestsDesc,
                                    icon: Icons.hail_rounded,
                                    actionLabel: l10n.submitPrayerRequest,
                                    onActionPressed: () =>
                                        triggerAddPrayerRequest(context),
                                  ),
                                ),
                              );
                            }

                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 340,
                                crossAxisSpacing: PRFSpacingTokens.lg,
                                mainAxisSpacing: PRFSpacingTokens.lg,
                                childAspectRatio: 1.4,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final prayerRequest = requests[index];
                                  return buildAnimatedTimelineEntry(
                                    context: context,
                                    index: index,
                                    animate: animateEntrance,
                                    child: PrayerRequestCard(
                                      prayerRequest: prayerRequest,
                                    ),
                                  );
                                },
                                childCount: requests.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sidePanel: PRFBrandPanel(
            children: [
              PRFPanelSectionLabel(l10n.prayerRequests),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.submitPrayerRequestDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Wrap(
                spacing: PRFSpacingTokens.sm,
                runSpacing: PRFSpacingTokens.sm,
                children: [
                  PrayerStatPill(
                    label: l10n.total,
                    value: prayerRequests.length,
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xxl),
              Center(
                child: Icon(
                  Icons.hail_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.prayerSummaryTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.prayerPanelBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              PRFButton(
                variant: PRFButtonVariant.secondary,
                onPressed: () => triggerAddPrayerRequest(context),
                title: l10n.submitPrayerRequest,
              ),
            ],
          ),
        );
      },
    );
  }
}
