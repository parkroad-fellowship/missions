import 'package:app/features/home/prayer_requests/actions/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/get_prayer_requests_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:app/shared_widgets/navbar/navbar.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PrayerRequestTablet extends StatefulWidget {
  const PrayerRequestTablet({super.key});

  @override
  State<PrayerRequestTablet> createState() => _PrayerRequestTabletState();
}

class _PrayerRequestTabletState extends State<PrayerRequestTablet> {
  @override
  void initState() {
    super.initState();
    context.read<GetPrayerRequestsCubit>().fetchPrayerRequests();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.prayerRequests,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              backgroundColor: theme.colorScheme.surface,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver:
                  BlocBuilder<GetPrayerRequestsCubit, GetPrayerRequestsState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        loading: () => const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        ),
                        error: (message) => SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh: () => context
                                .read<GetPrayerRequestsCubit>()
                                .fetchPrayerRequests(),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: PRFEmptyView(
                                label: l10n.noPrayerRequests,
                                description: message,
                                icon: Icons.hail_rounded,
                              ),
                            ),
                          ),
                        ),
                        loaded: (prayerRequests) {
                          if (prayerRequests.isEmpty) {
                            return SliverFillRemaining(
                              child: RefreshIndicator(
                                onRefresh: () => context
                                    .read<GetPrayerRequestsCubit>()
                                    .fetchPrayerRequests(),
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: PRFEmptyView(
                                    label: l10n.noPrayerRequests,
                                    description: l10n.noPrayerRequestsDesc,
                                    icon: Icons.hail_rounded,
                                    actionLabel: l10n.submitPrayerRequest,
                                    onActionPressed: _addPrayerRequest,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.only(bottom: 100),
                            sliver: SliverList.separated(
                              itemCount: prayerRequests.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 24),
                              itemBuilder: (context, index) {
                                final prayerRequest = prayerRequests[index];
                                return PrayerRequestCard(
                                      prayerRequest: prayerRequest,
                                    )
                                    .animate(
                                      delay: Duration(milliseconds: 80 * index),
                                    )
                                    .fadeIn(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    )
                                    .slideY(begin: 0.1, end: 0)
                                    .scale(
                                      begin: const Offset(0.95, 0.95),
                                      end: const Offset(1, 1),
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOutCubic,
                                    );
                              },
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            FloatingActionButton.extended(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: const Icon(Icons.add),
              label: Text(
                l10n.submitPrayerRequest,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              onPressed: _addPrayerRequest,
            ).animate(
              effects: [
                const ShimmerEffect(
                  duration: Duration(seconds: 2),
                  delay: Duration(milliseconds: 500),
                ),
                const ScaleEffect(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1, 1),
                  duration: Duration(milliseconds: 400),
                ),
              ],
            ),
      ),
    );
  }

  void _addPrayerRequest() {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) => [
        WoltModalSheetPage(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: const AddPrayerRequestView(),
          ),
        ),
      ],
    ).then((_) {
      if (!mounted) return;
      context.read<GetPrayerRequestsCubit>().fetchPrayerRequests();
    });
  }
}
