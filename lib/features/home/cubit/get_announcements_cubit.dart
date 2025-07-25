import 'package:app/services/_index.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_announcements_state.dart';
part 'get_announcements_cubit.freezed.dart';

class GetAnnouncementsCubit extends Cubit<GetAnnouncementsState> {
  GetAnnouncementsCubit({
    required AnnouncementService announcementService,
    required HiveService hiveService,
    required IsarService isarService,
  }) : super(const GetAnnouncementsState.initial()) {
    _announcementService = announcementService;
    _hiveService = hiveService;
    _isarService = isarService;
  }

  late AnnouncementService _announcementService;
  late HiveService _hiveService;
  late IsarService _isarService;

  Future<void> getAnnouncements() async {
    emit(const GetAnnouncementsState.loading());

    try {
      final memberGroupUlids = _hiveService.retrieveMemberGroupUlids();

      final announcements = await _announcementService.list(
        filters: {
          'group_ulids': memberGroupUlids.join(','),
          'upcoming': true,
        },
        orderBy: 'published_at',
        orderDirection: 'desc',
      );

      await _isarService.announcements.persistEntities(announcements);
      await _isarService.announcements.refreshStream();

      emit(GetAnnouncementsState.loaded(isEmpty: announcements.isEmpty));
    } catch (e) {
      emit(GetAnnouncementsState.error(e.toString()));
    }
  }
}
