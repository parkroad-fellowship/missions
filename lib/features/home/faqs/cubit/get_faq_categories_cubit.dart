import 'package:app/models/local/faq/prf_faq_category.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faq_categories_state.dart';
part 'get_faq_categories_cubit.freezed.dart';

class GetFaqCategoriesCubit extends Cubit<GetFaqCategoriesState> {
  GetFaqCategoriesCubit({
    required MissionFaqCategoryService missionFaqCategoryService,
    required IsarService isarService,
  }) : super(const GetFaqCategoriesState.initial()) {
    _missionFaqCategoryService = missionFaqCategoryService;
    _isarService = isarService;
  }

  late MissionFaqCategoryService _missionFaqCategoryService;
  late IsarService _isarService;

  Future<void> getFaqCategories({
    bool forceRefresh = false,
    String? query,
  }) async {
    emit(const GetFaqCategoriesState.loading());
    try {
      final localFaqCategories = await _isarService.faqCategories.list();
      if (localFaqCategories.isNotEmpty && !forceRefresh) {
        emit(GetFaqCategoriesState.loaded(faqCategories: localFaqCategories));
        return;
      }

      if (localFaqCategories.isEmpty || forceRefresh) {
        await _networkFetch();

        final localFaqCategories = await _isarService.faqCategories.list();
        emit(GetFaqCategoriesState.loaded(faqCategories: localFaqCategories));
        return;
      }
    } catch (e) {
      emit(GetFaqCategoriesState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final faqCategories = await _missionFaqCategoryService.list();
    if (faqCategories.isEmpty) {
      return;
    }
    await _isarService.faqCategories.persistEntities(faqCategories);
  }
}
