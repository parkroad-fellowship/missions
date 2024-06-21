import 'package:isar/isar.dart';

part 'prf_course.g.dart';

@collection
class PRFLocalCourse {
  PRFLocalCourse({
    required this.ulid,
    required this.name,
    required this.slug,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnail,
    this.courseMember,
  });

  Id id = Isar.autoIncrement;

  late String ulid;
  late String name;
  late String slug;
  late String description;
  late int isActive;
  late DateTime createdAt;
  late DateTime updatedAt;
  PRFLocalMedia? thumbnail;
  PRFLocalCourseMember? courseMember;
}

@embedded
class PRFLocalCourseMember {
  PRFLocalCourseMember({
     this.ulid,
     this.percentComplete,
     this.completionStatus,
     this.createdAt,
     this.updatedAt,
    this.completedAt,
  });

   String? ulid;
   double? percentComplete;
   int? completionStatus;
   DateTime? createdAt;
   DateTime? updatedAt;
  DateTime? completedAt;
}

@embedded
class PRFLocalMedia {

  PRFLocalMedia({
     this.publicURL,
     this.publicFullURL,
     this.size,
     this.humanReadableSize,
     this.mimeType,
     this.name,
     this.fileName,
     this.collectionName,
     this.createdAt,
     this.updatedAt,
  });

   String? publicURL;
   String? publicFullURL;
   int? size;
   String? humanReadableSize;
   String? mimeType;
   String? name;
   String? fileName;
   String? collectionName;
   DateTime? createdAt;
   DateTime? updatedAt;
}
