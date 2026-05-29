import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class PrayerRequestHiveDbService extends BaseHiveDbService<PRFPrayerRequest> {
  @override
  String get boxName => 'prf_prayer_requests';

  @override
  String getKey(PRFPrayerRequest entity) => entity.ulid;

  @override
  PRFPrayerRequest fromJson(Map<String, dynamic> json) =>
      PRFPrayerRequest.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFPrayerRequest entity) => entity.toJson();
}
