import 'package:app/features/home/prayer_requests/_shared.dart';
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

class PrayerRequestTablet extends StatefulWidget {
  const PrayerRequestTablet({super.key});

  @override
  State<PrayerRequestTablet> createState() => _PrayerRequestTabletState();
}

class _PrayerRequestTabletState extends State<PrayerRequestTablet> {
  final _form = PrayerRequestsFormState();

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
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

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
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Prayer Requests (flex: 3)
                    Expanded(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: () async => _form.load(context),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.lg,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () => context.router.back(),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.prayerRequests,
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.refresh_rounded),
                                      onPressed: () => _form.load(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                listLoading: (_) => const SliverFillRemaining(
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
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: columns,
                                          crossAxisSpacing: PRFSpacingTokens.lg,
                                          mainAxisSpacing: PRFSpacingTokens.lg,
                                          childAspectRatio: 1.4,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final prayerRequest = requests[index];
                                        return PrayerRequestCard(
                                              prayerRequest: prayerRequest,
                                            )
                                            .animate(
                                              delay: Duration(
                                                milliseconds: 70 * index,
                                              ),
                                            )
                                            .fadeIn(
                                              duration:
                                                  PRFMotionTokens.enterShort,
                                            )
                                            .slideY(begin: 0.15, end: 0);
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

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Prayer Request Stats & Actions (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prayer Summary',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Stats Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.md,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.submitPrayerRequestDesc,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: PrayerStatPill(
                                          label: l10n.total,
                                          value: prayerRequests.length,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.md,
                                      ),
                                      Expanded(
                                        child: PrayerStatPill(
                                          label: l10n.activeNow,
                                          value: prayerRequests.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Helpful guidance card
                            Center(
                              child: Icon(
                                Icons.hail_rounded,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Submit a Prayer Request',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Submit your prayer needs directly to the fellowship. Together in one spirit, we stand in prayer watch and lift up our requests.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),

                            // Submit request button
                            PRFButton(
                              onPressed: () => triggerAddPrayerRequest(context),
                              title: l10n.submitPrayerRequest,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
