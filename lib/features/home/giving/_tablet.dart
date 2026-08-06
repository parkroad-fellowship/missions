import 'package:app/enums/payment/prf_payment_status.dart';
import 'package:app/features/home/giving/_shared.dart';
import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class GivingPageTablet extends StatefulWidget {
  const GivingPageTablet({super.key});

  @override
  State<GivingPageTablet> createState() => _GivingPageTabletState();
}

class _GivingPageTabletState extends State<GivingPageTablet> {
  final _form = GivingFormState();

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

    return BlocBuilder<PaymentResourceCubit, ResourceState<PRFPayment>>(
      builder: (context, state) {
        final payments = state.maybeWhen(
          listLoaded: (values, _, _) => values,
          orElse: List<PRFPayment>.empty,
        );
        final successfulCount = payments
            .where(
              (payment) => payment.paymentStatus == PRFPaymentStatus.success,
            )
            .length;
        final pendingCount = payments
            .where(
              (payment) =>
                  payment.paymentStatus == PRFPaymentStatus.pending ||
                  payment.paymentStatus == PRFPaymentStatus.initialised,
            )
            .length;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Recent Payments list/grid (flex: 3)
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
                                      onPressed: () =>
                                          context.router.popUntilRouteWithPath(
                                            PRFSuperAppRouter.landingRoute,
                                          ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.give,
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
                                      label: l10n.considerGiving,
                                      description: message,
                                      icon: Icons.error_outline_rounded,
                                    ),
                                  ),
                                ),
                                listLoaded: (values, _, _) {
                                  if (values.isEmpty) {
                                    return SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: PRFEmptyView(
                                          label: l10n.considerGiving,
                                          description: l10n.startGiving,
                                          icon:
                                              Icons.volunteer_activism_rounded,
                                          actionLabel: l10n.give,
                                          onActionPressed: () =>
                                              triggerAddPayment(context),
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
                                          childAspectRatio: 1.5,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final payment = values[index];
                                        return Material(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    PRFRadiusTokens.xl,
                                                  ),
                                              child: InkWell(
                                                onTap: () => showPaymentActions(
                                                  context,
                                                  payment,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      PRFRadiusTokens.xl,
                                                    ),
                                                child: PaymentCard(
                                                  payment: payment,
                                                ),
                                              ),
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
                                            .slideY(
                                              begin: 0.22,
                                              end: 0,
                                              duration:
                                                  PRFMotionTokens.enterMedium,
                                              curve: Curves.easeOutCubic,
                                            );
                                      },
                                      childCount: values.length,
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

                    // Right Column - Total Giving Statistics & Sidebar Actions (flex: 2)
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
                              'Giving Summary',
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
                                    l10n.startGiving,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GivingStatPill(
                                          label: l10n.total,
                                          value: payments.length,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.xs,
                                      ),
                                      Expanded(
                                        child: GivingStatPill(
                                          label: 'Pending',
                                          value: pendingCount,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.xs,
                                      ),
                                      Expanded(
                                        child: GivingStatPill(
                                          label: 'Complete',
                                          value: successfulCount,
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
                                Icons.volunteer_activism_rounded,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Support Fellowship Missions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Your giving enables spiritual growth and supports critical missions, local requisitions, and fellowship operations.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),

                            // Action button
                            PRFButton(
                              onPressed: () => triggerAddPayment(context),
                              title: l10n.give,
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
