import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_prayer_response_state.dart';
part 'save_prayer_response_cubit.freezed.dart';

class SavePrayerResponseCubit extends Cubit<SavePrayerResponseState> {
  SavePrayerResponseCubit({
    required LocalDBService localDBService,
    required HiveService hiveService,
  }) : super(const SavePrayerResponseState.initial()) {
    _localDBService = localDBService;
    _hiveService = hiveService;
  }

  late LocalDBService _localDBService;
  late HiveService _hiveService;

  Future<void> savePrayerResponse({required String prayerPromptUlid}) async {
    final member = _hiveService.retrieveMember()!;

    await _localDBService.persistPrayerResponses(
      prayerResponses: [
        PRFPrayerResponseDTO(
          prayerPromptUlid: prayerPromptUlid,
          memberUlid: member.ulid,
        ),
      ],
    );

    emit(const SavePrayerResponseState.loaded());
  }
}
