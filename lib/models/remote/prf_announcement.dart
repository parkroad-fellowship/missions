import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_announcement.freezed.dart';
part 'prf_announcement.g.dart';

@freezed
abstract class PRFAnnouncement with _$PRFAnnouncement {
  factory PRFAnnouncement(
    String ulid,
    String title,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'published_at') DateTime publishedAt,
  ) = _PRFAnnouncement;

  factory PRFAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$PRFAnnouncementFromJson(json);
}

@freezed
abstract class PRFAnnouncementResponse with _$PRFAnnouncementResponse {
  factory PRFAnnouncementResponse(List<PRFAnnouncement> data) =
      _PRFAnnouncementResponse;

  factory PRFAnnouncementResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFAnnouncementResponseFromJson(json);
}
