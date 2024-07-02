import 'package:isar/isar.dart';

part 'prf_announcement.g.dart';

@collection
class PRFLocalAnnouncement {
  PRFLocalAnnouncement({
    required this.ulid,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
}
