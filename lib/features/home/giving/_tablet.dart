import 'package:app/enums/payment/prf_payment_status.dart';
import 'package:app/features/home/giving/_shared.dart';
import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class GivingPageTablet extends StatefulWidget {
  const GivingPageTablet({super.key});

  @override
  State<GivingPageTablet> createState() => _GivingPageTabletState();
}

class _GivingPageTabletState extends State<GivingPageTablet> {
  final _form = GivingFormState();

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

    return BlocBuilder<PaymentResourceCubit, ResourceState<PRFPayment>>(
      builder: (context, state) {
        final payments = context.read<PaymentResourceCubit>().currentItems;
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

        // The entrance cascade plays exactly once per screen instance;
        // later rebuilds (refresh setState) and scrolled-in cards skip it.
        final animateEntrance = !_entrancePlayed;
        _entrancePlayed = true;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.give,
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
                          listLoading: (_) => payments.isEmpty
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
                                    icon: Icons.volunteer_activism_rounded,
                                    actionLabel: l10n.give,
                                    onActionPressed: () =>
                                        triggerAddPayment(context),
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
                                    childAspectRatio: 1.5,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final payment = values[index];
                                  return buildAnimatedTimelineEntry(
                                    context: context,
                                    index: index,
                                    animate: animateEntrance,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.xl,
                                      ),
                                      child: InkWell(
                                        onTap: () => showPaymentActions(
                                          context,
                                          payment,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          PRFRadiusTokens.xl,
                                        ),
                                        child: PaymentCard(
                                          payment: payment,
                                        ),
                                      ),
                                    ),
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
            ],
          ),
          sidePanel: PRFBrandPanel(
            children: [
              PRFPanelSectionLabel(l10n.givingSummary),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.startGiving,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              Wrap(
                spacing: PRFSpacingTokens.sm,
                runSpacing: PRFSpacingTokens.sm,
                children: [
                  GivingStatPill(
                    label: l10n.total,
                    value: payments.length,
                  ),
                  GivingStatPill(
                    label: l10n.pendingStatus,
                    value: pendingCount,
                  ),
                  GivingStatPill(
                    label: l10n.complete,
                    value: successfulCount,
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xxl),
              Center(
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.supportFellowshipMissions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.givingPanelBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              PRFButton(
                variant: PRFButtonVariant.secondary,
                onPressed: () => triggerAddPayment(context),
                title: l10n.give,
              ),
            ],
          ),
        );
      },
    );
  }
}
