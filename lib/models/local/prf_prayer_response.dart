import 'package:isar/isar.dart';

part 'prf_prayer_response.g.dart';

@collection
class PRFLocalPrayerResponse {
  PRFLocalPrayerResponse({
    required this.memberUlid,
    required this.prayerPromptUlid,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true)
  final String prayerPromptUlid;
  final String memberUlid;
}
