import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_announcements_state.dart';
part 'get_announcements_cubit.freezed.dart';

class GetAnnouncementsCubit extends Cubit<GetAnnouncementsState> {
  GetAnnouncementsCubit({
    required MissionService missionService,
    required LocalDBService localDBService,
    required HiveService hiveService,
  }) : super(const GetAnnouncementsState.initial()) {
    _missionService = missionService;
    _localDBService = localDBService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late LocalDBService _localDBService;
  late HiveService _hiveService;

  Future<void> getAnnouncements() async {
    emit(const GetAnnouncementsState.loading());

    try {
      final memberGroupUlids = _hiveService.retrieveMemberGroupUlids();

      final announcements = await _missionService.getAnnouncements(
        groups: memberGroupUlids ?? [],
        upcoming: true,
      );

      await _localDBService.persistAnnouncements(announcements: announcements);

      emit(GetAnnouncementsState.loaded(isEmpty: announcements.isEmpty));
    } catch (e) {
      emit(GetAnnouncementsState.error(e.toString()));
    }
  }
}
