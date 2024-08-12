import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'upload_prayer_response_state.dart';
part 'upload_prayer_response_cubit.freezed.dart';

class UploadPrayerResponseCubit extends Cubit<UploadPrayerResponseState> {
  UploadPrayerResponseCubit({
    required LocalDBService localDBService,
    required MissionService missionService,
  }) : super(const UploadPrayerResponseState.initial()) {
    _localDBService = localDBService;
    _missionService = missionService;
  }

  late LocalDBService _localDBService;
  late MissionService _missionService;

  Future<void> uploadPrayerResponses() async {
    try {
      final prayerResponses = _localDBService.retrievePrayerResponses();

      final responses = <Future<PRFPrayerResponse>>[];

      for (final prayerResponse in prayerResponses) {
        responses.add(
          Future<PRFPrayerResponse>(() async {
            return _missionService.respondToPrayerPrompt(
              prayerResponse: prayerResponse,
            );
          }),
        );
      }

      final results = await Future.wait(responses);
      Logger().f(results);

      for (final result in results) {
        _localDBService.deletePrayerResponse(
          prayerPromptUlid: result.prayerPrompt!.ulid,
        );
      }

      emit(const UploadPrayerResponseState.loaded());
    } catch (_) {}
  }
}
