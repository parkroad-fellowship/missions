import 'package:app/models/remote/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_prayer_request.freezed.dart';
part 'prf_prayer_request.g.dart';

@freezed
class PRFPrayerRequest with _$PRFPrayerRequest {
  factory PRFPrayerRequest({
    required String ulid,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') required String description,
    PRFMember? member,
  }) = _PRFPrayerRequest;

  factory PRFPrayerRequest.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerRequestFromJson(json);
}
