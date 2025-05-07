import 'package:app/features/home/prayer_requests/add_prayer_request/add_prayer_request.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_cubit.dart';
import 'package:app/features/home/prayer_requests/widgets/prayer_request_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    context.read<PrayerRequestCubit>().fetchPrayerRequests();
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
                              () => context.router.pushNamed(
                                PRFSuperAppRouter.landingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.prayerRequest,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Visibility(
                          child: Icon(Icons.abc, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<PrayerRequestCubit, PrayerRequestState>(
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
              BlocBuilder<PrayerRequestCubit, PrayerRequestState>(
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
                    loaded: (prayerRequests) {
                      if (prayerRequests.isEmpty) {
                        return SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh:
                                () =>
                                    context
                                        .read<PrayerRequestCubit>()
                                        .fetchPrayerRequests(),
                            child: Center(
                              child: PRFPrimaryButton(
                                title: l10n.submitPrayerRequest,
                                disabled: false,
                                onPressed: _addPrayerRequest,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList.separated(
                        itemCount: prayerRequests.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 24.h),
                        itemBuilder: (context, index) {
                          final prayerRequest = prayerRequests[index];
                          return PrayerRequestCard(
                            prayerRequest: prayerRequest,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Animate(
        effects: const [
          ShimmerEffect(
            duration: Duration(seconds: 2),
            delay: Duration(milliseconds: 500),
          ),
        ],
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: _addPrayerRequest,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _addPrayerRequest() => WoltModalSheet.show<void>(
    context: context,
    pageListBuilder:
        (modalSheetContext) => [
          WoltModalSheetPage(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: const AddPrayerRequestView(),
            ),
          ),
        ],
  ).then((_) {
    context.read<PrayerRequestCubit>().fetchPrayerRequests();
  });
}
