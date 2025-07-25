import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_prayer_response_state.dart';
part 'save_prayer_response_cubit.freezed.dart';

class SavePrayerResponseCubit extends Cubit<SavePrayerResponseState> {
  SavePrayerResponseCubit({
    required IsarService isarService,
    required HiveService hiveService,
  }) : super(const SavePrayerResponseState.initial()) {
    _isarService = isarService;
    _hiveService = hiveService;
  }

  late IsarService _isarService;
  late HiveService _hiveService;

  Future<void> savePrayerResponse({required String prayerPromptUlid}) async {
    final member = _hiveService.retrieveMember()!;

    await _isarService.prayerResponses.persistEntities(
      [
        PRFPrayerResponseDTO(
          prayerPromptUlid: prayerPromptUlid,
          memberUlid: member.ulid,
        ),
      ],
    );

    emit(const SavePrayerResponseState.loaded());
  }
}
