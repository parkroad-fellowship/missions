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

class GivingPageHandset extends StatefulWidget {
  const GivingPageHandset({super.key});

  @override
  State<GivingPageHandset> createState() => _GivingPageHandsetState();
}

class _GivingPageHandsetState extends State<GivingPageHandset> {
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
          backgroundColor: theme.colorScheme.surface,
          body: Column(
            children: [
              buildGivingHeader(
                context,
                theme,
                l10n,
                payments,
                pendingCount,
                successfulCount,
                () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
                () => _form.load(context),
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
                                    icon: Icons.volunteer_activism_rounded,
                                    actionLabel: l10n.give,
                                    onActionPressed: () =>
                                        triggerAddPayment(context),
                                  ),
                                ),
                              );
                            }

                            return SliverList.builder(
                              itemCount: values.length + 1,
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
                                            l10n.recentPayments,
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
                                          '${values.length}',
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

                                final paymentIndex = index - 1;
                                final payment = values[paymentIndex];
                                return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            paymentIndex == values.length - 1
                                            ? 0
                                            : PRFSpacingTokens.lg,
                                      ),
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
                                          splashColor: theme.colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          highlightColor: theme
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.05),
                                          child: PaymentCard(payment: payment),
                                        ),
                                      ),
                                    )
                                    .animate(
                                      delay: Duration(
                                        milliseconds: 70 * paymentIndex,
                                      ),
                                    )
                                    .fadeIn(
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideY(
                                      begin: 0.22,
                                      end: 0,
                                      duration: PRFMotionTokens.enterMedium,
                                      curve: Curves.easeOutCubic,
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
                      onPressed: () => triggerAddPayment(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        l10n.give,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
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
