import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqCategoryResourceCubit extends ResourceCubit<PRFFaqCategory> {
  FaqCategoryResourceCubit({
    required MissionFaqCategoryService missionFaqCategoryService,
    BaseLocalDBService<PRFFaqCategory, dynamic>? dbService,
  }) : super(service: missionFaqCategoryService, dbService: dbService);
}
