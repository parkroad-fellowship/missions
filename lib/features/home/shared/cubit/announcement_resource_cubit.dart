import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class AnnouncementResourceCubit extends ResourceCubit<PRFAnnouncement> {
  AnnouncementResourceCubit({
    required AnnouncementService announcementService,
    BaseLocalDBService<PRFAnnouncement, dynamic>? dbService,
  }) : super(service: announcementService, dbService: dbService);

  @override
  String? get defaultOrderBy => 'published_at';

  @override
  String? get defaultOrderDirection => 'desc';
}
