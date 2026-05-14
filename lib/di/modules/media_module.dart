import 'package:app/services/audio_playback_service.dart';
import 'package:app/services/audio_recording_service.dart';
import 'package:app/services/failed_recording_upload_service.dart';
import 'package:app/services/media_service.dart';
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
      ..registerSingleton<FailedRecordingUploadService>(
        FailedRecordingUploadService(
          isarService: getIt(),
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      );
  }
}
