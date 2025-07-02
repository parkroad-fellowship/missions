import 'package:app/services/_index.dart';
import 'package:app/services/api/prayer_prompt_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_prayer_prompts_state.dart';
part 'get_prayer_prompts_cubit.freezed.dart';

class GetPrayerPromptsCubit extends Cubit<GetPrayerPromptsState> {
  GetPrayerPromptsCubit({
    required PrayerPromptService prayerPromptService,
    required NotificationService notificationService,
  }) : super(const GetPrayerPromptsState.initial()) {
    _prayerPromptService = prayerPromptService;
    _notificationService = notificationService;
  }

  late PrayerPromptService _prayerPromptService;
  late NotificationService _notificationService;

  Future<void> getPrayerPrompts() async {
    emit(const GetPrayerPromptsState.loading());

    try {
      final prayerPrompts = await _prayerPromptService.list(
        limit: 100,
        filters: const {
          'filter[is_active]': 2,
        },
      );

      await _notificationService.schedulePrayerPromptNotifications(
        prayerPrompts: prayerPrompts,
      );

      emit(const GetPrayerPromptsState.loaded());
    } catch (e) {
      emit(GetPrayerPromptsState.error(e.toString()));
    }
  }
}
