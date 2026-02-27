import 'package:app/models/remote/member/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_prayer_request.freezed.dart';
part 'prf_prayer_request.g.dart';

@freezed
abstract class PRFPrayerRequest with _$PRFPrayerRequest {
  factory PRFPrayerRequest({
    required String ulid,
    required String title,
    required String description,
    PRFMember? member,
  }) = _PRFPrayerRequest;

  factory PRFPrayerRequest.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerRequestFromJson(json);
}

@freezed
abstract class PRFPrayerRequestResponse with _$PRFPrayerRequestResponse {
  factory PRFPrayerRequestResponse({required List<PRFPrayerRequest> data}) =
      _PRFPrayerRequestResponse;

  factory PRFPrayerRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerRequestResponseFromJson(json);
}
