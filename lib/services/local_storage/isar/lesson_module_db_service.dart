import 'dart:async';

import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_lesson_module.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class LessonModuleDbService
    extends BaseLocalDBService<PRFLessonModule, PRFLocalLessonModule> {
  LessonModuleDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalLessonModule> get collection =>
      dbInstance.pRFLocalLessonModules;

  @override
  PRFLocalLessonModule remoteToLocal(PRFLessonModule remote) {
    return PRFLocalLessonModule(
      ulid: remote.ulid,
      order: remote.order,
      lessonUlid: remote.lesson!.ulid,
      moduleUlid: remote.module!.ulid,
      createdAt: remote.createdAt,
      lessonMember: remote.lessonMember != null
          ? PRFLocalLessonMember(
              ulid: remote.lessonMember!.ulid,
              completionStatus: remote.lessonMember!.completionStatus,
              createdAt: remote.lessonMember!.createdAt,
              completedAt: remote.lessonMember!.completedAt,
            )
          : null,
      lesson: PRFLocalLesson(
        ulid: remote.lesson!.ulid,
        name: remote.lesson!.name,
        description: remote.lesson!.description,
        type: remote.lesson!.type,
        createdAt: remote.lesson!.createdAt,
        content: remote.lesson!.content,
        videoUrl: remote.lesson!.videoUrl,
        audioUrl: remote.lesson!.audioUrl,
        documentUrl: remote.lesson!.documentUrl,
        audios: remote.lesson!.audios
            ?.map(
              (audio) => PRFLocalMedia(
                collectionName: audio.collectionName,
                fileName: audio.fileName,
                temporaryURL: audio.temporaryURL,
                size: audio.size,
                humanReadableSize: audio.humanReadableSize,
                mimeType: audio.mimeType,
                name: audio.name,
                createdAt: audio.createdAt,
                updatedAt: audio.updatedAt,
              ),
            )
            .toList(),
        documents: remote.lesson!.documents
            ?.map(
              (document) => PRFLocalMedia(
                collectionName: document.collectionName,
                fileName: document.fileName,
                temporaryURL: document.temporaryURL,
                size: document.size,
                humanReadableSize: document.humanReadableSize,
                mimeType: document.mimeType,
                name: document.name,
                createdAt: document.createdAt,
                updatedAt: document.updatedAt,
              ),
            )
            .toList(),
        videos: remote.lesson!.videos
            ?.map(
              (video) => PRFLocalMedia(
                collectionName: video.collectionName,
                fileName: video.fileName,
                temporaryURL: video.temporaryURL,
                size: video.size,
                humanReadableSize: video.humanReadableSize,
                mimeType: video.mimeType,
                name: video.name,
                createdAt: video.createdAt,
                updatedAt: video.updatedAt,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<List<PRFLocalLessonModule>> listParentLessons(
    String parentKey,
  ) async {
    return collection
        .where()
        .moduleUlidEqualTo(parentKey)
        .sortByOrder()
        .findAll();
  }

  StreamController<List<PRFLocalLessonModule>>? _parentStreamController;
  Stream<List<PRFLocalLessonModule>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalLessonModule>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalLessonModule>>.broadcast();
    final entities = await listParentLessons(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }

  @override
  Future<PRFLocalLessonModule?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }
}
