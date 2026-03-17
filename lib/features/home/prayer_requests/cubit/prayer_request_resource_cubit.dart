import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PrayerRequestResourceCubit extends ResourceCubit<PRFPrayerRequest> {
  PrayerRequestResourceCubit({
    required PrayerRequestService prayerRequestService,
    BaseLocalDBService<PRFPrayerRequest, dynamic>? dbService,
  }) : super(service: prayerRequestService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['member'];

  /// Create a prayer request.
  Future<void> createPrayerRequest({
    required Map<String, dynamic> data,
  }) async {
    await create(data: data);
  }
}
