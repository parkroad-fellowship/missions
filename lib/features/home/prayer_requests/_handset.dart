import 'package:app/features/home/prayer_requests/_shared.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class PrayerRequestHandset extends StatefulWidget {
  const PrayerRequestHandset({super.key});

  @override
  State<PrayerRequestHandset> createState() => _PrayerRequestHandsetState();
}

class _PrayerRequestHandsetState extends State<PrayerRequestHandset> {
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
    final animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

    return BlocBuilder<
      PrayerRequestResourceCubit,
      ResourceState<PRFPrayerRequest>
    >(
      builder: (context, state) {
        // Same source as the list: pull-to-refresh keeps cards visible
        // instead of flashing a full-screen spinner.
        final prayerRequests = context
            .read<PrayerRequestResourceCubit>()
            .currentItems;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              buildPrayerHeader(
                context,
                theme,
                l10n,
                prayerRequests,
                () => context.router.back(),
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
                        padding: const EdgeInsets.fromLTRB(
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          PRFSpacingTokens.lg,
                          110,
                        ),
                        sliver: state.maybeWhen(
                          orElse: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
                          ),
                          listLoading: (_) => prayerRequests.isEmpty
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
                                    description: l10n.noPrayerRequestsDesc,
                                    icon: Icons.hail_rounded,
                                    actionLabel: l10n.submitPrayerRequest,
                                    onActionPressed: () =>
                                        triggerAddPrayerRequest(context),
                                  ),
                                ),
                              );
                            }

                            return SliverList.builder(
                              itemCount: requests.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: PRFSpacingTokens.md,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.recentPrayerRequests,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.78),
                                                ),
                                          ),
                                        ),
                                        Text(
                                          '${requests.length}',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final requestIndex = index - 1;
                                final prayerRequest = requests[requestIndex];
                                return buildAnimatedTimelineEntry(
                                  context: context,
                                  index: requestIndex,
                                  animate: animateEntrance,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          requestIndex == requests.length - 1
                                          ? 0
                                          : PRFSpacingTokens.lg,
                                    ),
                                    child: PrayerRequestCard(
                                      prayerRequest: prayerRequest,
                                    ),
                                  ),
                                );
                              },
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
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              boxShadow: PRFShadowTokens.badge(theme.colorScheme.primary),
            ),
            child:
                FloatingActionButton.extended(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.submitPrayerRequest),
                      onPressed: () => triggerAddPrayerRequest(context),
                    )
                    .animate()
                    .fadeIn(duration: PRFMotionTokens.enterMedium)
                    .slideY(begin: 0.2, end: 0),
          ),
        );
      },
    );
  }
}
