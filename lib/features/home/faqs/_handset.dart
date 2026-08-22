import 'package:app/features/home/faqs/_shared.dart';
import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/shared/widgets/build_animated_timeline_entry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MemberFAQPageHandset extends StatefulWidget {
  const MemberFAQPageHandset({super.key});

  @override
  State<MemberFAQPageHandset> createState() => _MemberFAQPageHandsetState();
}

class _MemberFAQPageHandsetState extends State<MemberFAQPageHandset> {
  final _form = FaqsFormState();

  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

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
    final animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

    return BlocBuilder<FaqResourceCubit, ResourceState<PRFFaq>>(
      builder: (context, faqState) {
        return BlocBuilder<
          FaqCategoryResourceCubit,
          ResourceState<PRFFaqCategory>
        >(
          builder: (context, categoryState) {
            // Same source as the list: pull-to-refresh keeps cards visible
            // instead of flashing a full-screen spinner.
            final faqs = context.read<FaqResourceCubit>().currentItems;
            final categories = categoryState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFFaqCategory>.empty,
            );

            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: Column(
                children: [
                  buildFaqsHeader(
                    context,
                    theme,
                    l10n,
                    faqs.length,
                    categories.length,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _form.refreshAll(context),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
                                    selectedCategory: _form.selectedCategory,
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
                              listLoading: (_) => faqs.isEmpty
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
                                        description: l10n.noFaqsDesc,
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
                                    return buildAnimatedTimelineEntry(
                                      context: context,
                                      index: faqIndex,
                                      animate: animateEntrance,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: faqIndex == values.length - 1
                                              ? 0
                                              : PRFSpacingTokens.md,
                                        ),
                                        child: FaqCard(faq: values[faqIndex]),
                                      ),
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
            );
          },
        );
      },
    );
  }
}
