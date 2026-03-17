import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
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
    context.read<FaqResourceCubit>().loadAll();
    super.initState();
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

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern Navigation Bar
            PRFNavBar(
              title: l10n.questions,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              backgroundColor: theme.colorScheme.surface,
            ),
            // Search Field
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.lg,
                ),
                child: PRFTextInput(
                  hintText: l10n.whatWouldYouLikeToKnow,
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    Logger().i('Search Query: $_searchQuery');
                    _searchDebouncer.run(() {
                      context.read<FaqResourceCubit>().loadAll(
                        filters: {
                          if (_selectedCategory?.ulid != null)
                            'mission_faq_category_ulid':
                                _selectedCategory!.ulid,
                          if (_searchQuery?.isNotEmpty ?? false)
                            'search': _searchQuery,
                        },
                      );
                    });
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.lg),
            ),

            // FAQ Categories
            SliverToBoxAdapter(
              child:
                  BlocBuilder<
                    FaqCategoryResourceCubit,
                    ResourceState<PRFFaqCategory>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: PRFLinearProgressIndicator.new,
                        listLoaded: (faqCategories, _, __) =>
                            PRFCategoryChips<PRFFaqCategory>(
                              categories: faqCategories,
                              selectedCategory: _selectedCategory,
                              labelBuilder: (c) => c.name,
                              allLabel: l10n.all.toUpperCase(),
                              onCategorySelected: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                                Logger().i(
                                  'Selected Category: $_selectedCategory',
                                );
                                context.read<FaqResourceCubit>().loadAll(
                                  filters: {
                                    if (newValue?.ulid != null)
                                      'mission_faq_category_ulid':
                                          newValue!.ulid,
                                    if (_searchQuery?.isNotEmpty ?? false)
                                      'search': _searchQuery,
                                  },
                                );
                              },
                            ),
                      );
                    },
                  ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.lg),
            ),

            // Loading Indicator
            SliverToBoxAdapter(
              child: BlocBuilder<FaqResourceCubit, ResourceState<PRFFaq>>(
                builder: (context, state) => state.maybeWhen(
                  listLoading: () => const PRFLinearProgressIndicator(),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.lg),
            ),

            // FAQ List
            BlocBuilder<FaqResourceCubit, ResourceState<PRFFaq>>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (message, _) => SliverFillRemaining(
                    child: Center(child: Text(message)),
                  ),
                  listLoaded: (faqs, _, __) {
                    if (faqs.isEmpty) {
                      return SliverFillRemaining(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<FaqResourceCubit>().loadAll(),
                          child: PRFEmptyView(
                            label: l10n.noFaqs,
                            description: l10n.pleaseWait,
                          ),
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: faqs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: PRFSpacingTokens.md),
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
  const FaqCard({required this.faq, super.key});

  final PRFFaq faq;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Animate(
      effects: const [SaturateEffect()],
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.lg,
          vertical: PRFSpacingTokens.xs,
        ),
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            faq.question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: PRFSpacingTokens.sm,
                  bottom: PRFSpacingTokens.sm,
                  right: PRFSpacingTokens.sm,
                ),
                child: Text(
                  faq.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
