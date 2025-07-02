import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/models/remote/prf_prayer_request_dto.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_prayer_request_cubit.freezed.dart';
part 'add_prayer_request_state.dart';

class AddPrayerRequestCubit extends Cubit<AddPrayerRequestState> {
  AddPrayerRequestCubit({
    required HiveService hiveService,
    required PrayerRequestService prayerRequestService,
  }) : _hiveService = hiveService,
       _prayerRequestService = prayerRequestService,
       super(const AddPrayerRequestState.initial());
  final HiveService _hiveService;
  final PrayerRequestService _prayerRequestService;

  Future<void> addPrayerRequest({
    required String title,
    required String description,
  }) async {
    emit(const AddPrayerRequestState.loading());

    final member = _hiveService.retrieveMember()!;

    try {
      final prayerRequest = await _prayerRequestService.create(
        data: PRFPrayerRequestDTO(
          title: title,
          description: description,
          memberUlid: member.ulid,
        ).toJson(),
        includes: ['member'],
      );
      emit(AddPrayerRequestState.loaded(prayerRequests: [prayerRequest]));
    } on Failure catch (e) {
      emit(AddPrayerRequestState.error(e.message));
    } catch (e) {
      emit(AddPrayerRequestState.error(e.toString()));
    }
  }
}
