import 'package:app/models/remote/prayer/prf_prayer_response.dart';
import 'package:app/services/api/_base_api_service.dart';

class PrayerResponseService extends BaseAPIService<PRFPrayerResponse> {
  @override
  String get endpoint => '/prayer-responses';

  @override
  PRFPrayerResponse createFromJson(Map<String, dynamic> json) {
    return PRFPrayerResponse.fromJson(json);
  }

  @override
  List<PRFPrayerResponse> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    throw UnimplementedError(
      'createListFromResponse is not implemented for PrayerResponseService',
    );
  }
}
