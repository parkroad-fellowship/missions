import 'package:app/features/home/prayer_requests/actions/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<PrayerRequestResourceCubit>().loadAll();
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
        final prayerRequests = state.maybeWhen(
          listLoaded: (requests, _, _) => requests,
          orElse: List<PRFPrayerRequest>.empty,
        );

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.88),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    PRFBrandedNavBar(
                      title: l10n.prayerRequests,
                      onBack: () => context.router.back(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.xs,
                        PRFSpacingTokens.lg,
                        PRFSpacingTokens.lg,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PRFSpacingTokens.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.submitPrayerRequestDesc,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Wrap(
                              spacing: PRFSpacingTokens.xs,
                              runSpacing: PRFSpacingTokens.xs,
                              children: [
                                _PrayerStatPill(
                                  label: l10n.total,
                                  value: prayerRequests.length,
                                ),
                                _PrayerStatPill(
                                  label: l10n.activeNow,
                                  value: prayerRequests.length,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<PrayerRequestResourceCubit>().loadAll(),
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
                          listLoading: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: PRFCircularProgressIndicator(),
                            ),
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
                                    onActionPressed: _addPrayerRequest,
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
                                return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            requestIndex == requests.length - 1
                                            ? 0
                                            : PRFSpacingTokens.lg,
                                      ),
                                      child: PrayerRequestCard(
                                        prayerRequest: prayerRequest,
                                      ),
                                    )
                                    .animate(
                                      delay: Duration(
                                        milliseconds: 70 * requestIndex,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideY(begin: 0.15, end: 0);
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
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child:
                FloatingActionButton.extended(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.submitPrayerRequest),
                      onPressed: _addPrayerRequest,
                    )
                    .animate()
                    .fadeIn(duration: PRFMotionTokens.enterMedium)
                    .slideY(begin: 0.2, end: 0),
          ),
        );
      },
    );
  }

  void _addPrayerRequest() =>
      PRFBottomSheet.show<void>(
        context,
        title: context.l10n.submitPrayerRequest,
        child: const AddPrayerRequestView(),
      ).then((_) {
        if (!mounted) return;
        context.read<PrayerRequestResourceCubit>().loadAll();
      });
}

class _PrayerStatPill extends StatelessWidget {
  const _PrayerStatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
