import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqCategoryResourceCubit extends ResourceCubit<PRFFaqCategory> {
  FaqCategoryResourceCubit({
    required MissionFaqCategoryService missionFaqCategoryService,
    required HiveService hiveService,
  }) : super(
         service: missionFaqCategoryService,
         dbService: hiveService.faqCategories,
       );

  @override
  Future<List<PRFFaqCategory>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
