import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/services/api/_base_api_service.dart';

class PrayerPromptService extends BaseAPIService<PRFPrayerPrompt> {
  @override
  String get endpoint => '/prayer-prompts';

  @override
  PRFPrayerPrompt createFromJson(Map<String, dynamic> json) {
    return PRFPrayerPrompt.fromJson(json);
  }

  @override
  List<PRFPrayerPrompt> createListFromResponse(Map<String, dynamic> response) {
    return PRFPrayerPromptResponse.fromJson(response).data;
  }
}
