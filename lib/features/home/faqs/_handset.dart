import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_faq.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberFAQPageHandset extends StatefulWidget {
  const MemberFAQPageHandset({super.key});

  @override
  State<MemberFAQPageHandset> createState() => _MemberFAQPageHandsetState();
}

class _MemberFAQPageHandsetState extends State<MemberFAQPageHandset> {
  @override
  void initState() {
    context.read<GetFaqsCubit>().getFaqs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Start Navigation Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: true,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.appTheme().kPrimaryColorV2,
                          width: 1.w,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: const EdgeInsets.only(left: 8),
                        onPressed: () => context.router.popUntilRouteWithPath(
                          PRFSuperAppRouter.landingRoute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.questions,
                      style: CustomTextTheme.customTextTheme()
                          .displayLarge
                          ?.copyWith(fontSize: 80.sp),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // End Navigation Bar
            SliverToBoxAdapter(child: SizedBox(height: 48.h)),
            SliverToBoxAdapter(
              child: BlocBuilder<GetFaqsCubit, GetFaqsState>(
                builder: (context, state) => state.maybeWhen(
                  orElse: () => const Center(child: LinearProgressIndicator()),
                  error: (message) => Center(child: Text(message)),
                  loaded: (_) => const SizedBox.shrink(),
                ),
              ),
            ),
            BlocBuilder<GetFaqsCubit, GetFaqsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (message) =>
                      SliverToBoxAdapter(child: Center(child: Text(message))),
                  loaded: (faqs) {
                    if (faqs.isEmpty) {
                      return SliverFillRemaining(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<GetFaqsCubit>().getFaqs(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Icon(
                                Icons.directions_walk,
                              ),
                              Center(
                                child: Text(
                                  l10n.noFaqs,
                                  style: CustomTextTheme.customTextTheme()
                                      .headlineMedium!
                                      .copyWith(
                                        color:
                                            AppTheme.appTheme().kDullGreyColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      l10n.pleaseWait,
                                      style: CustomTextTheme.customTextTheme()
                                          .displayLarge!
                                          .copyWith(
                                            color: AppTheme.appTheme()
                                                .kPrimaryColorV2,
                                            fontSize: 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: faqs.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) =>
                          FaqCard(faq: faqs[index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FaqCard extends StatelessWidget {
  const FaqCard({
    required this.faq,
    super.key,
  });

  final PRFFaq faq;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 60.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.appTheme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: CustomTextTheme.customTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  faq.answer,
                  style: CustomTextTheme.customTextTheme().bodySmall!.copyWith(
                        color: AppTheme.appTheme().kBlackColor,
                      ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
