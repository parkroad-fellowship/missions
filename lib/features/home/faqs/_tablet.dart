import 'package:app/features/home/faqs/_shared.dart';
import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/shared/widgets/build_animated_timeline_entry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MemberFAQPageTablet extends StatefulWidget {
  const MemberFAQPageTablet({super.key});

  @override
  State<MemberFAQPageTablet> createState() => _MemberFAQPageTabletState();
}

class _MemberFAQPageTabletState extends State<MemberFAQPageTablet> {
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

    return BlocBuilder<FaqResourceCubit, ResourceState<PRFFaq>>(
      builder: (context, faqState) {
        return BlocBuilder<
          FaqCategoryResourceCubit,
          ResourceState<PRFFaqCategory>
        >(
          builder: (context, categoryState) {
            final faqs = context.read<FaqResourceCubit>().currentItems;
            final categories = context
                .read<FaqCategoryResourceCubit>()
                .currentItems;

            // The entrance cascade plays exactly once per screen instance;
            // later rebuilds (refresh setState) and scrolled-in cards skip it.
            final animateEntrance = !_entrancePlayed;
            _entrancePlayed = true;

            return PRFTabletSplitScaffold(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PRFTabletHeaderRow(
                    title: l10n.questions,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.landingRoute,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      PRFSpacingTokens.lg,
                      0,
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.lg,
                    ),
                    child: PRFTextField(
                      hintText: l10n.whatWouldYouLikeToKnow,
                      controller: _form.searchController,
                      onChanged: (value) {
                        _form.setSearchQuery(value, context);
                      },
                    ),
                  ),
                  categoryState.maybeWhen(
                    orElse: () => const SizedBox.shrink(),
                    listLoading: (_) => const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.lg,
                      ),
                      child: PRFLinearProgressIndicator(),
                    ),
                    listLoaded: (faqCategories, _, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.lg,
                      ),
                      child: PRFCategoryChips<PRFFaqCategory>(
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
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _form.refreshAll(context),
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
                                  itemCount: values.length,
                                  itemBuilder: (context, index) {
                                    return buildAnimatedTimelineEntry(
                                      context: context,
                                      index: index,
                                      animate: animateEntrance,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: PRFSpacingTokens.md,
                                        ),
                                        child: FaqCard(
                                          faq: values[index],
                                        ),
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
              sidePanel: PRFBrandPanel(
                children: [
                  PRFPanelSectionLabel(l10n.helpCenter),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.whatWouldYouLikeToKnow,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: PRFColors.navy100,
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  Wrap(
                    spacing: PRFSpacingTokens.sm,
                    runSpacing: PRFSpacingTokens.sm,
                    children: [
                      FaqStatPill(
                        label: l10n.total,
                        value: faqs.length,
                      ),
                      FaqStatPill(
                        label: l10n.categories,
                        value: categories.length,
                      ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  Center(
                    child: Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: PRFOpacities.half),
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.findQuickAnswers,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  Text(
                    l10n.faqsPanelBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: PRFColors.navy100,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
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
