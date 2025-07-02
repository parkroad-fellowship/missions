import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faq_categories_state.dart';
part 'get_faq_categories_cubit.freezed.dart';

class GetFaqCategoriesCubit extends Cubit<GetFaqCategoriesState> {
  GetFaqCategoriesCubit({
    required MissionFaqCategoryService missionFaqCategoryService,
    required LocalDBService localDBService,
  }) : super(const GetFaqCategoriesState.initial()) {
    _missionFaqCategoryService = missionFaqCategoryService;
    _localDBService = localDBService;
  }

  late MissionFaqCategoryService _missionFaqCategoryService;
  late LocalDBService _localDBService;

  Future<void> getFaqCategories({
    bool forceRefresh = false,
    String? query,
  }) async {
    emit(const GetFaqCategoriesState.loading());
    try {
      final localFaqCategories = await _localDBService.retreiveFaqCategories();
      if (localFaqCategories.isNotEmpty && !forceRefresh) {
        emit(GetFaqCategoriesState.loaded(faqCategories: localFaqCategories));
        return;
      }

      if (localFaqCategories.isEmpty || forceRefresh) {
        await _networkFetch();

        final localFaqCategories = await _localDBService
            .retreiveFaqCategories();
        emit(GetFaqCategoriesState.loaded(faqCategories: localFaqCategories));
        return;
      }
    } catch (e) {
      emit(GetFaqCategoriesState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final faqCategories = await _missionFaqCategoryService.list();
    await _localDBService.persistFaqCategories(faqCategories: faqCategories);
  }
}
