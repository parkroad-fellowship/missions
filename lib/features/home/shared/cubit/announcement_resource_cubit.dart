import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class AnnouncementResourceCubit extends ResourceCubit<PRFAnnouncement> {
  AnnouncementResourceCubit({
    required AnnouncementService announcementService,
    required HiveService hiveService,
  }) : super(
         service: announcementService,
         dbService: hiveService.announcements,
       );

  @override
  String? get defaultSortBy => '-published_at';
}
