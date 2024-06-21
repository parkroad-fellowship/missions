import 'package:app/models/remote/prf_lesson_member.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_lesson.freezed.dart';
part 'prf_lesson.g.dart';

@freezed
class PRFLesson with _$PRFLesson {
  factory PRFLesson(
    String ulid,
    String name,
    String slug,
    String description,
    String type,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    String? content,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'audio_url') String? audioUrl,
    @JsonKey(name: 'document_url') String? documentUrl,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    List<PRFMedia>? audios,
    List<PRFMedia>? documents,
    List<PRFMedia>? videos,
    PRFMedia? thumbnail,
    @JsonKey(name: 'lesson_member') PRFLessonMember? lessonMember,
  }) = _PRFLesson;

  factory PRFLesson.fromJson(Map<String, dynamic> json) =>
      _$PRFLessonFromJson(json);
}
