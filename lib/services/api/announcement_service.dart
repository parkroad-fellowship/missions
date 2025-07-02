import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/services/api/_base_api_service.dart';

class AnnouncementService extends BaseAPIService<PRFAnnouncement> {
  @override
  String get endpoint => '/announcements';

  @override
  PRFAnnouncement createFromJson(Map<String, dynamic> json) {
    return PRFAnnouncement.fromJson(json);
  }

  @override
  List<PRFAnnouncement> createListFromResponse(Map<String, dynamic> response) {
    return PRFAnnouncementResponse.fromJson(response).data;
  }
}
