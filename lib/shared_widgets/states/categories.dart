import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/faq/prf_faq_category.dart';
import 'package:app/shared_widgets/progress/linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqCategoriesPreview extends StatefulWidget {
  const FaqCategoriesPreview({required this.onCategorySelected, super.key});

  final void Function(PRFLocalFaqCategory?) onCategorySelected;

  @override
  State<FaqCategoriesPreview> createState() => _FaqCategoriesPreviewState();
}

class _FaqCategoriesPreviewState extends State<FaqCategoriesPreview> {
  PRFLocalFaqCategory? _selectedCategory;

  @override
  void initState() {
    context.read<GetFaqCategoriesCubit>().getFaqCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<GetFaqCategoriesCubit, GetFaqCategoriesState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: PRFLinearProgressIndicator.new,
            loaded: (faqCategories) => SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: faqCategories.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final isSelected = isAll
                      ? _selectedCategory == null
                      : _selectedCategory == faqCategories[index - 1];

                  final label = isAll
                      ? l10n.all.toUpperCase()
                      : faqCategories[index - 1].name.toUpperCase();

                  final selectedColor = theme.colorScheme.primary;
                  final unselectedColor = theme.colorScheme.surface;
                  final selectedTextColor = theme.colorScheme.onPrimary;
                  final unselectedTextColor = theme.colorScheme.primary;

                  return GestureDetector(
                    onTap: () {
                      widget.onCategorySelected(
                        isAll ? null : faqCategories[index - 1],
                      );
                      setState(() {
                        _selectedCategory = isAll
                            ? null
                            : faqCategories[index - 1];
                      });
                    },
                    child:
                        AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ), // less vertical padding
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? selectedColor
                                    : unselectedColor,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // slightly less round
                                border: Border.all(
                                  color: isSelected
                                      ? selectedColor.withValues(alpha: .5)
                                      : theme.colorScheme.outline.withValues(
                                          alpha: .3,
                                        ),
                                  width: 1.2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: selectedColor.withValues(
                                            alpha: .13,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? selectedTextColor
                                        : unselectedTextColor,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            )
                            .animate(target: isSelected ? 1 : 0)
                            .scaleXY(
                              begin: 1,
                              end: 1.06,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
