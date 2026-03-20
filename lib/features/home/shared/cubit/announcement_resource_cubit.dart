import 'package:app/models/remote/content/prf_announcement.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class AnnouncementResourceCubit extends ResourceCubit<PRFAnnouncement> {
  AnnouncementResourceCubit({
    required AnnouncementService announcementService,
    super.dbService,
  }) : super(service: announcementService);

  @override
  String? get defaultOrderBy => 'published_at';

  @override
  String? get defaultOrderDirection => 'desc';
}
