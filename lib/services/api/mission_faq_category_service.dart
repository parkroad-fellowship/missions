import 'package:app/models/remote/prf_faq_category.dart';
import 'package:app/services/api/_base_api_service.dart';

class MissionFaqCategoryService extends BaseAPIService<PRFFaqCategory> {
  @override
  String get endpoint => '/mission-faq-categories';

  @override
  PRFFaqCategory createFromJson(Map<String, dynamic> json) {
    return PRFFaqCategory.fromJson(json);
  }

  @override
  List<PRFFaqCategory> createListFromResponse(Map<String, dynamic> response) {
    return PRFFaqCategoryResponse.fromJson(response).data;
  }
}
