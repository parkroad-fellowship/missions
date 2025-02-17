import 'package:app/features/student_home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqCategoriesPreview extends StatefulWidget {
  const FaqCategoriesPreview({required this.onCategorySelected, super.key});

  final void Function(PRFLocalFaqCategory?) onCategorySelected;

  @override
  State<FaqCategoriesPreview> createState() => _FaqCategoriesPreviewState();
}

class _FaqCategoriesPreviewState extends State<FaqCategoriesPreview> {
  _FaqCategoriesPreviewState();

  PRFLocalFaqCategory? _selectedCategory;

  @override
  void initState() {
    context.read<GetFaqCategoriesCubit>().getFaqCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetFaqCategoriesCubit, GetFaqCategoriesState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: PRFCircularProgressIndicator.new,
                  loaded:
                      (faqCategories) => SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: faqCategories.length + 1,
                          separatorBuilder:
                              (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  widget.onCategorySelected(null);
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                },
                                child: Chip(
                                  label: Text(l10n.all.toUpperCase()),
                                  side: BorderSide(
                                    color: PRFApp.theme().kAccent12GreyColor,
                                  ),
                                  backgroundColor:
                                      _selectedCategory == null
                                          ? PRFApp.theme().kPrimaryColorV2
                                          : Colors.white,
                                  labelStyle: PRFText.theme().bodyMedium
                                      ?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _selectedCategory == null
                                                ? Colors.white
                                                : PRFApp.theme()
                                                    .kPrimaryColorV2,
                                      ),
                                ),
                              );
                            }

                            final faqCategory = faqCategories[index - 1];
                            return GestureDetector(
                              onTap: () {
                                widget.onCategorySelected(faqCategory);
                                setState(() {
                                  _selectedCategory = faqCategory;
                                });
                              },
                              child: Chip(
                                label: Text(faqCategory.name.toUpperCase()),
                                side: BorderSide(
                                  color: PRFApp.theme().kAccent12GreyColor,
                                  width: 1.w,
                                ),
                                backgroundColor:
                                    _selectedCategory == faqCategory
                                        ? PRFApp.theme().kPrimaryColorV2
                                        : Colors.white,
                                labelStyle: PRFText.theme().bodyMedium
                                    ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _selectedCategory == faqCategory
                                              ? Colors.white
                                              : PRFApp.theme().kPrimaryColorV2,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
