import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PrayerRequestResourceCubit extends ResourceCubit<PRFPrayerRequest> {
  PrayerRequestResourceCubit({
    required PrayerRequestService prayerRequestService,
    super.dbService,
  }) : super(service: prayerRequestService);

  @override
  List<String> get defaultIncludes => ['member'];

  /// Create a prayer request.
  Future<void> createPrayerRequest({
    required Map<String, dynamic> data,
  }) async {
    await create(data: data);
  }
}
