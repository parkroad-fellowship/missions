import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_prayer_prompts_state.dart';
part 'get_prayer_prompts_cubit.freezed.dart';

class GetPrayerPromptsCubit extends Cubit<GetPrayerPromptsState> {
  GetPrayerPromptsCubit({
    required MissionService missionService,
    required NotificationService notificationService,
  }) : super(const GetPrayerPromptsState.initial()) {
    _missionService = missionService;
    _notificationService = notificationService;
  }

  late MissionService _missionService;
  late NotificationService _notificationService;

  Future<void> getPrayerPrompts() async {
    emit(const GetPrayerPromptsState.loading());

    try {
      final prayerPrompts = await _missionService.getPrayerPrompts();

      await _notificationService.schedulePrayerPromptNotifications(
        prayerPrompts: prayerPrompts,
      );

      emit(const GetPrayerPromptsState.loaded());
    } catch (e) {
      emit(GetPrayerPromptsState.error(e.toString()));
    }
  }
}
