import 'package:app/features/home/faqs/_shared.dart';
import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MemberFAQPageTablet extends StatefulWidget {
  const MemberFAQPageTablet({super.key});

  @override
  State<MemberFAQPageTablet> createState() => _MemberFAQPageTabletState();
}

class _MemberFAQPageTabletState extends State<MemberFAQPageTablet> {
  final _form = FaqsFormState();

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..refreshAll(context);
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

    return BlocBuilder<FaqResourceCubit, ResourceState<PRFFaq>>(
      builder: (context, faqState) {
        return BlocBuilder<
          FaqCategoryResourceCubit,
          ResourceState<PRFFaqCategory>
        >(
          builder: (context, categoryState) {
            final faqs = faqState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFFaq>.empty,
            );
            final categories = categoryState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFFaqCategory>.empty,
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
                        // Left Column - FAQs & Filters (flex: 3)
                        Expanded(
                          flex: 3,
                          child: RefreshIndicator(
                            onRefresh: () => _form.refreshAll(context),
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PRFSpacingTokens.lg,
                                      vertical: PRFSpacingTokens.lg,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () => context.router
                                              .popUntilRouteWithPath(
                                                PRFSuperAppRouter.landingRoute,
                                              ),
                                        ),
                                        const SizedBox(
                                          width: PRFSpacingTokens.xs,
                                        ),
                                        Text(
                                          l10n.questions,
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.lg,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: PRFTextField(
                                      hintText: l10n.whatWouldYouLikeToKnow,
                                      controller: _form.searchController,
                                      onChanged: (value) {
                                        _form.setSearchQuery(value, context);
                                      },
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: categoryState.maybeWhen(
                                    orElse: () => const SizedBox.shrink(),
                                    listLoading: (_) =>
                                        const PRFLinearProgressIndicator(),
                                    listLoaded: (faqCategories, _, _) =>
                                        PRFCategoryChips<PRFFaqCategory>(
                                          categories: faqCategories,
                                          selectedCategory:
                                              _form.selectedCategory,
                                          labelBuilder: (c) => c.name,
                                          allLabel: l10n.all.toUpperCase(),
                                          onCategorySelected: (newValue) {
                                            _form.setSelectedCategory(
                                              newValue,
                                              context,
                                            );
                                          },
                                        ),
                                  ),
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: PRFSpacingTokens.lg),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    PRFSpacingTokens.lg,
                                    0,
                                    PRFSpacingTokens.lg,
                                    PRFSpacingTokens.xl,
                                  ),
                                  sliver: faqState.maybeWhen(
                                    orElse: () => const SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Center(
                                        child: PRFCircularProgressIndicator(),
                                      ),
                                    ),
                                    listLoading: (_) =>
                                        const SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Center(
                                            child:
                                                PRFCircularProgressIndicator(),
                                          ),
                                        ),
                                    error: (message, _) => SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: PRFEmptyView(
                                          label: l10n.noFaqs,
                                          description: message,
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
                                              label: l10n.noFaqs,
                                              description: l10n.pleaseWait,
                                            ),
                                          ),
                                        );
                                      }

                                      return SliverList.builder(
                                        itemCount: values.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: PRFSpacingTokens.md,
                                                ),
                                                child: FaqCard(
                                                  faq: values[index],
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
                                              .slideY(begin: 0.2, end: 0);
                                        },
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
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.12,
                          ),
                        ),

                        // Right Column - FAQ Info & Brand Panel (flex: 2)
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
                                  'Help Center',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.xl),

                                // FAQ Stats Card
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.whatWouldYouLikeToKnow,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: PRFSpacingTokens.lg,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FaqStatPill(
                                              label: l10n.total,
                                              value: faqs.length,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: PRFSpacingTokens.md,
                                          ),
                                          Expanded(
                                            child: FaqStatPill(
                                              label: l10n.categories,
                                              value: categories.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Guidance card
                                Center(
                                  child: Icon(
                                    Icons.quiz_outlined,
                                    size: 64,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Text(
                                  'Find Quick Answers',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: PRFSpacingTokens.sm),
                                Text(
                                  'Search through compiled FAQs or filter by categories on the left panel to find immediate guidelines about PRF Missions and fellowship rules.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
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
      },
    );
  }
}
