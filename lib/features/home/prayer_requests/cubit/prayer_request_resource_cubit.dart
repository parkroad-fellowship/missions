import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/models/remote/prayer/prf_prayer_request_dto.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PrayerRequestResourceCubit extends ResourceCubit<PRFPrayerRequest> {
  PrayerRequestResourceCubit({
    required PrayerRequestService prayerRequestService,
    required HiveService hiveService,
  }) : _hiveService = hiveService,
       super(
         service: prayerRequestService,
         dbService: hiveService.prayerRequests,
       );

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => ['member'];

  /// Create a prayer request.
  Future<void> createPrayerRequest({
    required String title,
    required String description,
  }) async {
    final dto = PRFPrayerRequestDTO(
      memberUlid: _hiveService.retrieveMember()!.ulid,
      title: title,
      description: description,
    );
    await create(data: dto.toJson());
  }
}
