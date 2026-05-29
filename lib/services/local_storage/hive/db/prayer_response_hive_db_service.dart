import 'package:app/models/remote/prayer/prf_prayer_response.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

/// Write-queue service for [PRFPrayerResponseDTO] objects that have been saved
/// locally but not yet uploaded to the API.
class PrayerResponseHiveDbService
    extends BaseHiveDbService<PRFPrayerResponseDTO> {
  @override
  String get boxName => 'prf_prayer_responses';

  @override
  String getKey(PRFPrayerResponseDTO entity) => entity.prayerPromptUlid;

  @override
  PRFPrayerResponseDTO fromJson(Map<String, dynamic> json) =>
      PRFPrayerResponseDTO.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFPrayerResponseDTO entity) => entity.toJson();
}
