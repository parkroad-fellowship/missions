import 'package:isar/isar.dart';

part 'shared_embeds.g.dart';

@embedded
class PRFLocalMember {
  PRFLocalMember({
    this.ulid,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
    this.bio,
  });

  final String? ulid;
  final String? fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? bio;
}

@embedded
class PRFLocalClassGroup {
  PRFLocalClassGroup({this.ulid, this.name});

  final String? ulid;
  final String? name;
}

@embedded
class PRFLocalMedia {
  PRFLocalMedia({
    this.temporaryURL,
    this.size,
    this.humanReadableSize,
    this.mimeType,
    this.name,
    this.fileName,
    this.collectionName,
    this.createdAt,
    this.updatedAt,
  });

  String? temporaryURL;
  int? size;
  String? humanReadableSize;
  String? mimeType;
  String? name;
  String? fileName;
  String? collectionName;
  DateTime? createdAt;
  DateTime? updatedAt;
}
