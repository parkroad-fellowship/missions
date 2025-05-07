import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/models/remote/prf_prayer_request_dto.dart';
import 'package:app/services/hive_service.dart';
import 'package:app/services/prayer_request_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_request_cubit.freezed.dart';
part 'prayer_request_state.dart';

class PrayerRequestCubit extends Cubit<PrayerRequestState> {
  PrayerRequestCubit({
    required HiveService hiveService,
    required PrayerRequestService prayerRequestService,
  }) : super(const PrayerRequestState.initial()) {
    _prayerRequestService = prayerRequestService;
    _hiveService = hiveService;
  }
  late HiveService _hiveService;
  late PrayerRequestService _prayerRequestService;

  Future<void> fetchPrayerRequests() async {
    emit(const PrayerRequestState.loading());
    final member = _hiveService.retrieveMember();
    if (member == null) {
      throw Failure(message: 'Member information not found');
    }

    try {
      final prayerRequests = await _prayerRequestService.getPrayerRequests(
        memberUlid: member.ulid,
      );
      emit(PrayerRequestState.loaded(prayerRequests: prayerRequests));
    } on Failure catch (e) {
      emit(PrayerRequestState.error(e.message));
    } catch (e) {
      emit(PrayerRequestState.error(e.toString()));
    }
  }

  Future<void> addPrayerRequest({
    required String title,
    required String description,
  }) async {
    emit(const PrayerRequestState.loading());
    try {
      final member = _hiveService.retrieveMember()!;

      final prayerRequest = await _prayerRequestService.addPrayerRequest(
        dto: PRFPrayerRequestDTO(
          title: title,
          description: description,
          memberUlid: member.ulid,
        ),
      );
      emit(PrayerRequestState.loaded(prayerRequests: [prayerRequest]));
    } on Failure catch (e) {
      emit(PrayerRequestState.error(e.message));
    } catch (e) {
      emit(PrayerRequestState.error(e.toString()));
    }
  }
}
