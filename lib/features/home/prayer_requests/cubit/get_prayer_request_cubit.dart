// fetch_prayer_request_cubit.dart
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/services/hive_service.dart';
import 'package:app/services/prayer_request_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_prayer_request_state.dart';
part 'get_prayer_request_cubit.freezed.dart';

class GetPrayerRequestCubit extends Cubit<GetPrayerRequestState> {
  GetPrayerRequestCubit({
    required HiveService hiveService,
    required PrayerRequestService prayerRequestService,
  }) : _hiveService = hiveService,
       _prayerRequestService = prayerRequestService,
       super(const GetPrayerRequestState.initial());
  final HiveService _hiveService;
  final PrayerRequestService _prayerRequestService;

  Future<void> fetchPrayerRequests() async {
    emit(const GetPrayerRequestState.loading());
    final member = _hiveService.retrieveMember();
    if (member == null) {
      emit(const GetPrayerRequestState.error('Member information not found'));
      return;
    }

    try {
      final prayerRequests = await _prayerRequestService.getPrayerRequests(
        memberUlid: member.ulid,
      );
      emit(GetPrayerRequestState.loaded(prayerRequests));
    } on Failure catch (e) {
      emit(GetPrayerRequestState.error(e.message));
    } catch (e) {
      emit(GetPrayerRequestState.error(e.toString()));
    }
  }
}
