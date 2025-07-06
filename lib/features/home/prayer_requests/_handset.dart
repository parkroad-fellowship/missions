import 'package:app/features/home/prayer_requests/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/get_prayer_requests_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PrayerRequestHandset extends StatefulWidget {
  const PrayerRequestHandset({super.key});

  @override
  State<PrayerRequestHandset> createState() => _PrayerRequestHandsetState();
}

class _PrayerRequestHandsetState extends State<PrayerRequestHandset> {
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            PRFNavBar(
              title: l10n.prayerRequests,
              onBack: () => context.router.back(),
              backgroundColor: theme.colorScheme.surface,
            ),

            BlocBuilder<GetPrayerRequestsCubit, GetPrayerRequestsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (message) => SliverFillRemaining(
                    child: Center(child: Text(message)),
                  ),
                  loaded: (prayerRequests) {
                    if (prayerRequests.isEmpty) {
                      return SliverFillRemaining(
                        child: RefreshIndicator(
                          onRefresh: () => context
                              .read<GetPrayerRequestsCubit>()
                              .fetchPrayerRequests(),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 64),
                              PRFEmptyView(
                                label: l10n.noPrayerRequests,
                                description: l10n.noPrayerRequestsDesc,
                                icon: Icons.self_improvement_rounded,
                                actionLabel: l10n.submitPrayerRequest,
                                onActionPressed: _addPrayerRequest,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList.separated(
                      itemCount: prayerRequests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final prayerRequest = prayerRequests[index];
                        return PrayerRequestCard(
                              prayerRequest: prayerRequest,
                            )
                            .animate(delay: Duration(milliseconds: 80 * index))
                            .fadeIn(duration: const Duration(milliseconds: 500))
                            .slideY(begin: 0.1, end: 0);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Animate(
        effects: const [
          ShimmerEffect(
            duration: Duration(seconds: 2),
            delay: Duration(milliseconds: 500),
          ),
        ],
        child: FloatingActionButton.extended(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          icon: const Icon(Icons.add),
          label: Text(l10n.submitPrayerRequest),
          onPressed: _addPrayerRequest,
        ),
      ),
    );
  }

  void _addPrayerRequest() =>
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
