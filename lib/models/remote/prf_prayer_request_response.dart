import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: directives_ordering
import 'package:app/models/remote/prf_prayer_request.dart';
part 'prf_prayer_request_response.freezed.dart';
part 'prf_prayer_request_response.g.dart';

@freezed
class PRFPrayerRequestResponse with _$PRFPrayerRequestResponse {
  factory PRFPrayerRequestResponse({required List<PRFPrayerRequest> data}) =
      _PRFPrayerRequestResponse;

  factory PRFPrayerRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerRequestResponseFromJson(json);
}
