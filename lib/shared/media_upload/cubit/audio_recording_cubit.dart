import 'dart:async';

import 'package:app/services/media/audio_recording_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'audio_recording_cubit.freezed.dart';
part 'audio_recording_state.dart';

class AudioRecordingCubit extends Cubit<AudioRecordingState> {
  AudioRecordingCubit({
    required AudioRecordingService recordingService,
  }) : super(const AudioRecordingState.initial()) {
    _recordingService = recordingService;
    _initialize();
  }

  late AudioRecordingService _recordingService;
  StreamSubscription<RecordingState>? _stateSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  void _initialize() {
    // Listen to recording state changes
    _stateSubscription = _recordingService.stateStream.listen((recordingState) {
      switch (recordingState) {
        case RecordingState.stopped:
          if (_recordingService.currentRecordingPath != null) {
            emit(
              AudioRecordingState.completed(
                filePath: _recordingService.currentRecordingPath!,
                duration: _recordingService.recordingDuration,
              ),
            );
          } else {
            emit(const AudioRecordingState.ready());
          }
        case RecordingState.recording:
          emit(
            AudioRecordingState.recording(
              duration: _recordingService.recordingDuration,
            ),
          );
        case RecordingState.paused:
          emit(
            AudioRecordingState.paused(
              duration: _recordingService.recordingDuration,
            ),
          );
        case RecordingState.error:
          emit(
            const AudioRecordingState.error(
              message: 'Recording failed. Please try again.',
            ),
          );
      }
    });

    // Listen to duration changes
    _durationSubscription = _recordingService.durationStream.listen((duration) {
      state.maybeWhen(
        recording: (_) =>
            emit(AudioRecordingState.recording(duration: duration)),
        paused: (_) => emit(AudioRecordingState.paused(duration: duration)),
        orElse: () {},
      );
    });

    // Initialize service when cubit is created
    _initializeService();
  }

  Future<void> _initializeService() async {
    // Check if permissions are available without requesting them yet
    final permissionStatus = await _recordingService.getPermissionStatus();

    if (permissionStatus.isGranted) {
      // If already granted, initialize
      final success = await _recordingService.initialize();
      if (success) {
        emit(const AudioRecordingState.ready());
      } else {
        emit(
          const AudioRecordingState.error(
            message: 'Failed to initialize recording service.',
          ),
        );
      }
    } else {
      // Permission not granted yet, but don't show error -
      // let user trigger the permission request
      emit(const AudioRecordingState.ready());
    }
  }

  Future<void> requestPermissions() async {
    final success = await _recordingService.initialize();
    if (success) {
      emit(const AudioRecordingState.ready());
    } else {
      final permissionStatus = await _recordingService.getPermissionStatus();
      if (permissionStatus.isPermanentlyDenied) {
        emit(
          const AudioRecordingState.error(
            message:
                'Microphone permission permanently denied. '
                'Please enable it in device settings.',
          ),
        );
      } else {
        emit(
          const AudioRecordingState.error(
            message: 'Microphone permission is required to record audio.',
          ),
        );
      }
    }
  }

  Future<void> startRecording({String? customPath}) async {
    // Check current permission status before attempting to record
    final permissionStatus = await _recordingService.getPermissionStatus();

    if (permissionStatus.isPermanentlyDenied) {
      emit(
        const AudioRecordingState.error(
          message:
              'Microphone permission permanently denied. '
              'Please enable it in device settings.',
        ),
      );
      return;
    }

    final success = await _recordingService.startRecording(
      customPath: customPath,
    );
    if (!success) {
      // Check if service didn't already emit an error state
      if (!state.maybeWhen(
        error: (_) => true,
        orElse: () => false,
      )) {
        emit(
          const AudioRecordingState.error(
            message:
                'Failed to start recording. '
                'Please check microphone permissions.',
          ),
        );
      }
    }
  }

  Future<void> pauseRecording() async {
    final success = await _recordingService.pauseRecording();
    if (!success) {
      emit(
        const AudioRecordingState.error(
          message: 'Failed to pause recording.',
        ),
      );
    }
  }

  Future<void> resumeRecording() async {
    final success = await _recordingService.resumeRecording();
    if (!success) {
      emit(
        const AudioRecordingState.error(
          message: 'Failed to resume recording.',
        ),
      );
    }
  }

  Future<String?> stopRecording() async => _recordingService.stopRecording();

  Future<void> cancelRecording() async {
    final success = await _recordingService.cancelRecording();
    if (success) {
      emit(const AudioRecordingState.ready());
    } else {
      emit(
        const AudioRecordingState.error(
          message: 'Failed to cancel recording.',
        ),
      );
    }
  }

  Future<void> resetRecording() async {
    await _recordingService.cancelRecording();
    emit(const AudioRecordingState.ready());
  }

  bool get isRecording => _recordingService.isRecording;
  bool get isPaused => _recordingService.isPaused;
  bool get hasError => _recordingService.hasError;

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }
}
