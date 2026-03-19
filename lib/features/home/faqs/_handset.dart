import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MemberFAQPageHandset extends StatefulWidget {
  const MemberFAQPageHandset({super.key});

  @override
  State<MemberFAQPageHandset> createState() => _MemberFAQPageHandsetState();
}

class _MemberFAQPageHandsetState extends State<MemberFAQPageHandset> {
  PRFFaqCategory? _selectedCategory;
  String? _searchQuery;

  final TextEditingController _searchController = TextEditingController();

  final _searchDebouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    context.read<FaqCategoryResourceCubit>().loadAll();
    _loadFaqs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
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
              backgroundColor: theme.colorScheme.surface,
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        PRFBrandedNavBar(
                          title: l10n.questions,
                          onBack: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.landingRoute,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            PRFSpacingTokens.lg,
                            PRFSpacingTokens.xs,
                            PRFSpacingTokens.lg,
                            PRFSpacingTokens.lg,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              PRFSpacingTokens.md,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onPrimary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.lg,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.whatWouldYouLikeToKnow,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary
                                        .withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(height: PRFSpacingTokens.md),
                                Wrap(
                                  spacing: PRFSpacingTokens.xs,
                                  runSpacing: PRFSpacingTokens.xs,
                                  children: [
                                    _FaqStatPill(
                                      label: l10n.total,
                                      value: faqs.length,
                                    ),
                                    _FaqStatPill(
                                      label: l10n.categories,
                                      value: categories.length,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshAll,
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
                              PRFSpacingTokens.lg,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: PRFTextInput(
                                hintText: l10n.whatWouldYouLikeToKnow,
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                  _searchDebouncer.run(_loadFaqs);
                                },
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: categoryState.maybeWhen(
                              orElse: () => const SizedBox.shrink(),
                              listLoading: PRFLinearProgressIndicator.new,
                              listLoaded: (faqCategories, _, _) =>
                                  PRFCategoryChips<PRFFaqCategory>(
                                    categories: faqCategories,
                                    selectedCategory: _selectedCategory,
                                    labelBuilder: (c) => c.name,
                                    allLabel: l10n.all.toUpperCase(),
                                    onCategorySelected: (newValue) {
                                      setState(() {
                                        _selectedCategory = newValue;
                                      });
                                      _loadFaqs();
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
                              listLoading: () => const SliverFillRemaining(
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
                                                l10n.recentFaqs,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.78,
                                                          ),
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

                                    final faqIndex = index - 1;
                                    return Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                faqIndex == values.length - 1
                                                ? 0
                                                : PRFSpacingTokens.md,
                                          ),
                                          child: FaqCard(faq: values[faqIndex]),
                                        )
                                        .animate(
                                          delay: Duration(
                                            milliseconds: 70 * faqIndex,
                                          ),
                                        )
                                        .fadeIn(
                                          duration: PRFMotionTokens.enterShort,
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadFaqs() {
    return context.read<FaqResourceCubit>().loadAll(
      filters: {
        if (_selectedCategory?.ulid != null)
          'mission_faq_category_ulid': _selectedCategory!.ulid,
        if (_searchQuery?.isNotEmpty ?? false) 'search': _searchQuery,
      },
    );
  }

  Future<void> _refreshAll() async {
    await context.read<FaqCategoryResourceCubit>().loadAll();
    await _loadFaqs();
  }
}

class FaqCard extends StatelessWidget {
  const FaqCard({required this.faq, super.key});

  final PRFFaq faq;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Animate(
      effects: const [SaturateEffect()],
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.md,
              vertical: PRFSpacingTokens.xs,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              PRFSpacingTokens.md,
              0,
              PRFSpacingTokens.md,
              PRFSpacingTokens.md,
            ),
            leading: Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
              ),
              child: Icon(
                Icons.quiz_rounded,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            title: Text(
              faq.question,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqStatPill extends StatelessWidget {
  const _FaqStatPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
