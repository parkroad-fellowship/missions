import 'package:app/models/local/prf_announcement.dart';
import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class AnnouncementResourceCubit
    extends ResourceCubit<PRFAnnouncement, PRFLocalAnnouncement> {
  AnnouncementResourceCubit({
    required AnnouncementService announcementService,
    super.dbService,
  }) : super(service: announcementService);

  @override
  String? get defaultSortBy => '-published_at';
}
