import 'package:app/models/local/prf_announcement.dart';
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class AnnouncementDbService
    extends BaseLocalDBService<PRFAnnouncement, PRFLocalAnnouncement> {
  AnnouncementDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalAnnouncement> get collection =>
      dbInstance.pRFLocalAnnouncements;

  @override
  PRFLocalAnnouncement remoteToLocal(PRFAnnouncement remote) =>
      PRFLocalAnnouncement(
        ulid: remote.ulid,
        title: remote.title,
        content: remote.content,
        createdAt: remote.createdAt,
        updatedAt: remote.updatedAt,
        publishedAt: remote.publishedAt,
      );

  Stream<Map<DateTime, List<PRFLocalAnnouncement>>> getAnnouncementsGrouped() {
    return getGroupedBy<DateTime>((announcement) => announcement.publishedAt);
  }
}
