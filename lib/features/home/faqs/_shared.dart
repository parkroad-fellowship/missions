import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class FaqsFormState {
  FaqsFormState();

  late final VoidCallback _rebuild;

  PRFFaqCategory? selectedCategory;
  String? searchQuery;

  final searchController = TextEditingController();
  final searchDebouncer = Debouncer(milliseconds: 1000);

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  void setSelectedCategory(PRFFaqCategory? category, BuildContext context) {
    selectedCategory = category;
    _rebuild();
    loadFaqs(context);
  }

  void setSearchQuery(String? query, BuildContext context) {
    searchQuery = query;
    _rebuild();
    searchDebouncer.run(() => loadFaqs(context));
  }

  void loadFaqs(BuildContext context) {
    context.read<FaqResourceCubit>().loadAll(
      refreshInBackground: false,
      filters: {
        if (selectedCategory?.ulid != null)
          'mission_faq_category_ulid': selectedCategory!.ulid,
        if (searchQuery?.isNotEmpty ?? false) 'search': searchQuery,
      },
    );
  }

  Future<void> refreshAll(BuildContext context) async {
    await context.read<FaqCategoryResourceCubit>().loadAll(
      refreshInBackground: false,
    );
    loadFaqs(context);
  }

  void dispose() {
    searchController.dispose();
    searchDebouncer.dispose();
  }
}

class FaqStatPill extends StatelessWidget {
  const FaqStatPill({required this.label, required this.value, super.key});

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
          boxShadow: PRFShadowTokens.raised(theme.colorScheme.primary),
        ),
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
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
      ),
    );
  }
}

Widget buildFaqsHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  int faqsCount,
  int categoriesCount,
) {
  return Container(
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
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Wrap(
                  spacing: PRFSpacingTokens.xs,
                  runSpacing: PRFSpacingTokens.xs,
                  children: [
                    FaqStatPill(
                      label: l10n.total,
                      value: faqsCount,
                    ),
                    FaqStatPill(
                      label: l10n.categories,
                      value: categoriesCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
