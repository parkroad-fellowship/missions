import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/services/api/_base_api_service.dart';

class PrayerRequestService extends BaseAPIService<PRFPrayerRequest> {
  @override
  String get endpoint => '/prayer-requests';

  @override
  PRFPrayerRequest createFromJson(Map<String, dynamic> json) {
    return PRFPrayerRequest.fromJson(json);
  }

  @override
  List<PRFPrayerRequest> createListFromResponse(Map<String, dynamic> response) {
    return PRFPrayerRequestResponse.fromJson(response).data;
  }
}
