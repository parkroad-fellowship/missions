import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_faq.dart';
import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class MemberFAQPageTablet extends StatefulWidget {
  const MemberFAQPageTablet({super.key});

  @override
  State<MemberFAQPageTablet> createState() => _MemberFAQPageTabletState();
}

class _MemberFAQPageTabletState extends State<MemberFAQPageTablet> {
  PRFLocalFaqCategory? _selectedCategory;
  String? _searchQuery;

  final _searchDeboucer = Debouncer(milliseconds: 1 * 1000);

  @override
  void initState() {
    context.read<GetFaqsCubit>().getFaqs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);

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
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.landingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.questions,
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
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      Logger().i('Search Query: $_searchQuery');

                      _searchDeboucer.run(() {
                        context.read<GetFaqsCubit>().getFaqs(
                          categoryUlid:
                              _selectedCategory?.ulid ??
                              _selectedCategory?.ulid,
                          query:
                              _searchQuery != null ||
                                      (_searchQuery?.isNotEmpty ?? false)
                                  ? _searchQuery
                                  : null,
                        );
                      });
                    },
                    decoration: InputDecoration(
                      hintText: l10n.whatWouldYouLikeToKnow,
                      suffixIconColor: Theme.of(context).colorScheme.primary,
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Icon(Icons.search),
                      ),
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetFaqsCubit, GetFaqsState>(
                  builder:
                      (context, state) => state.maybeWhen(
                        loading:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        orElse: () => const SizedBox.shrink(),
                      ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: FaqCategoriesPreview(
                  onCategorySelected: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                    Logger().i('Selected Category: $_selectedCategory');
                    context.read<GetFaqsCubit>().getFaqs(
                      categoryUlid: _selectedCategory?.ulid,
                      query:
                          _searchQuery != null ||
                                  (_searchQuery?.isNotEmpty ?? false)
                              ? _searchQuery
                              : null,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              BlocBuilder<GetFaqsCubit, GetFaqsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: SizedBox.shrink,
                    loading:
                        () => const SliverToBoxAdapter(
                          child: PRFLinearProgressIndicator(),
                        ),
                    error:
                        (message) => SliverFillRemaining(
                          child: Center(child: Text(message)),
                        ),
                    loaded: (faqs) {
                      if (faqs.isEmpty) {
                        return SliverFillRemaining(
                          child: RefreshIndicator(
                            onRefresh:
                                () => context.read<GetFaqsCubit>().getFaqs(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                const Icon(Icons.directions_walk),
                                Center(
                                  child: Text(
                                    l10n.noFaqs,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
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
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.displayLarge,
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
                        separatorBuilder:
                            (context, index) => SizedBox(height: 8.h),
                        itemBuilder:
                            (context, index) => FaqCard(faq: faqs[index]),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaqCard extends StatelessWidget {
  const FaqCard({required this.faq, super.key});

  final PRFLocalFaq faq;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.h),
                Text(faq.answer, style: Theme.of(context).textTheme.bodySmall),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
