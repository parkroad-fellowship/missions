import 'package:app/features/home/giving/add_payment/add_payment.dart';
import 'package:app/features/home/giving/cubit/get_payments_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_payment.dart';
import 'package:app/services/hive_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GivingPageHandset extends StatefulWidget {
  const GivingPageHandset({super.key});

  @override
  State<GivingPageHandset> createState() => _GivingPageHandsetState();
}

class _GivingPageHandsetState extends State<GivingPageHandset> {
  @override
  void initState() {
    super.initState();

    context.read<GetPaymentsCubit>().getPayments();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.landingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.give,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed:
                            () =>
                                context.read<GetPaymentsCubit>().getPayments(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetPaymentsCubit, GetPaymentsState>(
                  builder:
                      (context, state) => state.maybeWhen(
                        orElse:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => const SizedBox.shrink(),
                        loaded: (_) => const SizedBox.shrink(),
                      ),
                ),
              ),
              BlocBuilder<GetPaymentsCubit, GetPaymentsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse:
                        () => const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    error:
                        (message) => SliverFillRemaining(
                          child: Center(child: Text(message)),
                        ),
                    empty:
                        () => SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh:
                                () =>
                                    context
                                        .read<GetPaymentsCubit>()
                                        .getPayments(),
                            child: Center(
                              child: PRFPrimaryButton(
                                title: l10n.considerGiving,
                                disabled: false,
                                onPressed: _addPayment,
                              ),
                            ),
                          ),
                        ),
                    loaded:
                        (payments) => SliverList.separated(
                          itemCount: payments.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 8.h),
                          itemBuilder:
                              (context, index) =>
                                  PaymentCard(payment: payments[index]),
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _addPayment,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addPayment() => WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return [
        WoltModalSheetPage(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: const AddPaymentView(),
          ),
        ),
      ];
    },
  ).then((_) {
    // ignore: use_build_context_synchronously
    context.read<GetPaymentsCubit>().getPayments();
  });
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({required this.payment, super.key});

  final PRFPayment payment;

  String get timezone => getIt<HiveService>().timezone;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: NumberFormat.currency(
                            locale: 'en_KE',
                            symbol: 'KES ',
                          ).format(payment.amount),
                          style: Theme.of(context).textTheme.displayLarge,
                          children: [
                            TextSpan(
                              text: ', ${payment.paymentStatus.name}',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(Misc.formatDateTime(payment.createdAt, timezone)),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 4.h,
                  ),
                  child: Visibility(
                    // visible: payment.paymentStatus
                    // == PRFPaymentStatus.pending,
                    visible: false,
                    child: IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        if (payment.authorizationUrl != null) {
                          final uri = Uri.parse(payment.authorizationUrl!);
                          await Misc.openUrl(uri);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
