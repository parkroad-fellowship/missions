import 'package:app/features/home/prayer_requests/actions/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:prf_design/prf_design.dart';
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
    context.read<PrayerRequestResourceCubit>().loadAll();
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

            BlocBuilder<
              PrayerRequestResourceCubit,
              ResourceState<PRFPrayerRequest>
            >(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (message, _) => SliverFillRemaining(
                    child: Center(child: Text(message)),
                  ),
                  listLoaded: (prayerRequests, _, __) {
                    if (prayerRequests.isEmpty) {
                      return SliverFillRemaining(
                        child: RefreshIndicator(
                          onRefresh: () => context
                              .read<PrayerRequestResourceCubit>()
                              .loadAll(),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 64),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                ),
                                child: PRFEmptyView(
                                  label: l10n.noPrayerRequests,
                                  description: l10n.noPrayerRequestsDesc,
                                  icon: Icons.hail_rounded,
                                  actionLabel: l10n.submitPrayerRequest,
                                  onActionPressed: _addPrayerRequest,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList.separated(
                      itemCount: prayerRequests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: PRFSpacingTokens.xl),
                      itemBuilder: (context, index) {
                        final prayerRequest = prayerRequests[index];
                        return PrayerRequestCard(
                              prayerRequest: prayerRequest,
                            )
                            .animate(delay: Duration(milliseconds: 80 * index))
                            .fadeIn(duration: PRFMotionTokens.enterShort)
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
            delay: PRFMotionTokens.enterShort,
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
        context.read<PrayerRequestResourceCubit>().loadAll();
      });
}
