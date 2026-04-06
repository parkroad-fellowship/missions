import 'package:app/models/local/faq/prf_faq_category.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqCategoryResourceCubit
    extends ResourceCubit<PRFFaqCategory, PRFLocalFaqCategory> {
  FaqCategoryResourceCubit({
    required MissionFaqCategoryService missionFaqCategoryService,
    super.dbService,
  }) : super(service: missionFaqCategoryService);
}
