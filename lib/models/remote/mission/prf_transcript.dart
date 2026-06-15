import 'package:app/models/remote/media/prf_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_transcript.freezed.dart';
part 'prf_transcript.g.dart';

@freezed
abstract class PRFTranscript with _$PRFTranscript {
  factory PRFTranscript(
    String ulid, {
    @Default('') @JsonKey(name: 'transcription_content') String content,
    PRFMedia? media,
  }) = _PRFTranscript;

  factory PRFTranscript.fromJson(Map<String, dynamic> json) =>
      _$PRFTranscriptFromJson(json);
}
