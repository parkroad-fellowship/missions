import 'package:app/enums/prf_media_model.dart';
import 'package:isar_community/isar.dart';

part 'prf_media_upload.g.dart';

@collection
class PRFLocalMediaUpload {
  PRFLocalMediaUpload({
    required this.model,
    required this.modelUlid,
    required this.path,
  });

  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.ordinal32)
  final PRFMediaModel model;
  final String modelUlid;
  final String path;
}
