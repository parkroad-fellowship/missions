import 'package:app/services/media/audio_playback_service.dart';
import 'package:app/services/media/audio_recording_service.dart';
import 'package:app/services/media/failed_recording_upload_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:get_it/get_it.dart';

/// Media module for registering media-related services.
///
/// Includes:
/// - Media service
/// - Audio recording service
/// - Failed upload recovery service
class MediaModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<MediaService>(MediaServiceImpl())
      ..registerSingleton<AudioPlaybackService>(AudioPlaybackService())
      ..registerSingleton<AudioRecordingService>(AudioRecordingService())
      // This service touches Hive in its constructor, so defer creation
      // until after database initialization has completed.
      ..registerLazySingleton<FailedRecordingUploadService>(
        () => FailedRecordingUploadService(
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      );
  }
}
