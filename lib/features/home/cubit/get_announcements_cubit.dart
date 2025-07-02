import 'package:app/services/_index.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_announcements_state.dart';
part 'get_announcements_cubit.freezed.dart';

class GetAnnouncementsCubit extends Cubit<GetAnnouncementsState> {
  GetAnnouncementsCubit({
    required AnnouncementService announcementService,
    required LocalDBService localDBService,
    required HiveService hiveService,
  }) : super(const GetAnnouncementsState.initial()) {
    _announcementService = announcementService;
    _localDBService = localDBService;
    _hiveService = hiveService;
  }

  late AnnouncementService _announcementService;
  late LocalDBService _localDBService;
  late HiveService _hiveService;

  Future<void> getAnnouncements() async {
    emit(const GetAnnouncementsState.loading());

    try {
      final memberGroupUlids = _hiveService.retrieveMemberGroupUlids();

      final announcements = await _announcementService.list(
        filters: {
          'filter[group_ulids]': memberGroupUlids.join(','),
          'filter[upcoming]': true,
        },
        orderBy: 'published_at',
        orderDirection: 'desc',
      );

      await _localDBService.persistAnnouncements(announcements: announcements);

      emit(GetAnnouncementsState.loaded(isEmpty: announcements.isEmpty));
    } catch (e) {
      emit(GetAnnouncementsState.error(e.toString()));
    }
  }
}
