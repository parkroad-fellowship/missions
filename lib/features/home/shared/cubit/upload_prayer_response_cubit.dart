import 'package:app/models/remote/prayer/prf_prayer_response.dart';
import 'package:app/services/api/prayer_response_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'upload_prayer_response_state.dart';
part 'upload_prayer_response_cubit.freezed.dart';

class UploadPrayerResponseCubit extends Cubit<UploadPrayerResponseState> {
  UploadPrayerResponseCubit({
    required HiveService hiveService,
    required PrayerResponseService prayerResponseService,
  }) : super(const UploadPrayerResponseState.initial()) {
    _hiveService = hiveService;
    _prayerResponseService = prayerResponseService;
  }

  late HiveService _hiveService;
  late PrayerResponseService _prayerResponseService;

  Future<void> uploadPrayerResponses() async {
    try {
      final prayerResponses = await _hiveService.prayerResponses.list();

      final responses = <Future<PRFPrayerResponse>>[];

      for (final prayerResponse in prayerResponses) {
        responses.add(
          Future<PRFPrayerResponse>(() async {
            return _prayerResponseService.create(
              data: prayerResponse.toJson(),
              includes: ['prayerPrompt'],
            );
          }),
        );
      }

      final results = await Future.wait(responses);
      Logger().f(results);

      for (final result in results) {
        await _hiveService.prayerResponses.deleteByKey(
          result.prayerPrompt!.ulid,
        );
      }

      emit(const UploadPrayerResponseState.loaded());
    } catch (_) {}
  }
}
