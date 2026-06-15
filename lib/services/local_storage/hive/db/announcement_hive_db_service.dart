import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class AnnouncementHiveDbService extends BaseHiveDbService<PRFAnnouncement> {
  @override
  String get boxName => 'prf_announcements';

  @override
  String getKey(PRFAnnouncement entity) => entity.ulid;

  @override
  PRFAnnouncement fromJson(Map<String, dynamic> json) =>
      PRFAnnouncement.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFAnnouncement entity) => entity.toJson();
}
