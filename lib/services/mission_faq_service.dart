import 'package:app/models/remote/prf_faq.dart';
import 'package:app/services/_base_api_service.dart';

class MissionFaqService extends BaseAPIService<PRFFaq> {
  @override
  String get endpoint => '/mission-faqs';

  @override
  PRFFaq createFromJson(Map<String, dynamic> json) {
    return PRFFaq.fromJson(json);
  }

  @override
  List<PRFFaq> createListFromResponse(Map<String, dynamic> response) {
    return PRFFaqResponse.fromJson(response).data;
  }
}
