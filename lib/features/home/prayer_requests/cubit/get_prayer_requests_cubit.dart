import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/services/hive_service.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_prayer_requests_state.dart';
part 'get_prayer_requests_cubit.freezed.dart';

class GetPrayerRequestsCubit extends Cubit<GetPrayerRequestsState> {
  GetPrayerRequestsCubit({
    required HiveService hiveService,
    required PrayerRequestService prayerRequestService,
  }) : _hiveService = hiveService,
       _prayerRequestService = prayerRequestService,
       super(const GetPrayerRequestsState.initial());
  final HiveService _hiveService;
  final PrayerRequestService _prayerRequestService;

  Future<void> fetchPrayerRequests() async {
    try {
      emit(const GetPrayerRequestsState.loading());
      final member = _hiveService.retrieveMember()!;
      final prayerRequests = await _prayerRequestService.list(
        includes: ['member'],
        filters: {
          'filter[member_ulid]': member.ulid,
        },
      );
      emit(GetPrayerRequestsState.loaded(prayerRequests: prayerRequests));
    } on Failure catch (e) {
      emit(GetPrayerRequestsState.error(e.message));
    } catch (e) {
      emit(GetPrayerRequestsState.error(e.toString()));
    }
  }
}
