import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

enum RecordingState {
  stopped,
  recording,
  paused,
  error,
}

class AudioRecordingService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final StreamController<RecordingState> _stateController =
      StreamController<RecordingState>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();

  RecordingState _currentState = RecordingState.stopped;
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  Duration _pausedDuration = Duration.zero;

  // Getters
  Stream<RecordingState> get stateStream => _stateController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  RecordingState get currentState => _currentState;
  Duration get recordingDuration => _recordingDuration;
  String? get currentRecordingPath => _currentRecordingPath;

  /// Check current permission status
  Future<PermissionStatus> getPermissionStatus() async =>
      Permission.microphone.status;

  /// Request microphone permission
  Future<PermissionStatus> requestPermission() async =>
      Permission.microphone.request();

  /// Initialize the service and request permissions
  Future<bool> initialize() async {
    try {
      // Check current permission status first
      var status = await Permission.microphone.status;

      // If permission is not granted, request it
      if (!status.isGranted) {
        status = await Permission.microphone.request();

        // Handle different permission states
        if (status.isDenied) {
          throw Exception(
            'Microphone permission denied. '
            'Please allow microphone access in settings.',
          );
        } else if (status.isPermanentlyDenied) {
          throw Exception(
            'Microphone permission permanently denied. '
            'Please enable it in device settings.',
          );
        } else if (status.isRestricted) {
          throw Exception('Microphone access is restricted on this device.');
        }
      }

      // Double-check with the recorder package
      if (!await _audioRecorder.hasPermission()) {
        throw Exception(
          'Recording permission not available from audio recorder',
        );
      }

      Logger().d(
        'AudioRecordingService: '
        'Successfully initialized with microphone permission',
      );
      return true;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to initialize - $e');
      _updateState(RecordingState.error);
      return false;
    }
  }

  /// Start recording audio
  Future<bool> startRecording({String? customPath}) async {
    try {
      if (_currentState == RecordingState.recording) {
        Logger().d('AudioRecordingService: Already recording');
        return false;
      }

      // Check permission status before starting
      final permissionStatus = await getPermissionStatus();
      if (!permissionStatus.isGranted) {
        // Try to request permission again
        final newStatus = await requestPermission();
        if (!newStatus.isGranted) {
          if (newStatus.isPermanentlyDenied) {
            throw Exception(
              'Microphone permission is permanently denied. '
              'Please enable it in device settings.',
            );
          } else {
            throw Exception(
              'Microphone permission is required to record audio.',
            );
          }
        }
      }

      // Verify recorder has permission
      if (!await _audioRecorder.hasPermission()) {
        throw Exception('Audio recorder does not have permission');
      }

      // Generate recording path
      _currentRecordingPath = customPath ?? await _generateRecordingPath();

      // Configure recording settings for background recording
      const config = RecordConfig(
        numChannels: 1,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      );

      // Start recording
      await _audioRecorder.start(config, path: _currentRecordingPath!);

      // Reset timing for new recording
      _recordingDuration = Duration.zero;
      _pausedDuration = Duration.zero;
      _recordingStartTime = null;

      _updateState(RecordingState.recording);
      _startTimer();

      // Enable background audio session (iOS specific)
      if (Platform.isIOS) {
        await _configureAudioSession();
      }

      Logger().d(
        'AudioRecordingService: Recording started at $_currentRecordingPath',
      );
      return true;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to start recording - $e');
      _updateState(RecordingState.error);
      return false;
    }
  }

  /// Pause recording
  Future<bool> pauseRecording() async {
    try {
      if (_currentState != RecordingState.recording) {
        return false;
      }

      await _audioRecorder.pause();
      _updateState(RecordingState.paused);
      _stopTimer();

      Logger().d('AudioRecordingService: Recording paused');
      return true;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to pause recording - $e');
      _updateState(RecordingState.error);
      return false;
    }
  }

  /// Resume recording
  Future<bool> resumeRecording() async {
    try {
      if (_currentState != RecordingState.paused) {
        return false;
      }

      await _audioRecorder.resume();
      _updateState(RecordingState.recording);
      _startTimer();

      Logger().d('AudioRecordingService: Recording resumed');
      return true;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to resume recording - $e');
      _updateState(RecordingState.error);
      return false;
    }
  }

  /// Stop recording and return the file path
  Future<String?> stopRecording() async {
    try {
      if (_currentState == RecordingState.stopped) {
        return _currentRecordingPath;
      }

      final path = await _audioRecorder.stop();
      _updateState(RecordingState.stopped);
      _stopTimer();

      Logger().d('AudioRecordingService: Recording stopped at $path');
      return path;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to stop recording - $e');
      _updateState(RecordingState.error);
      return null;
    }
  }

  /// Cancel recording and delete the file
  Future<bool> cancelRecording() async {
    try {
      await stopRecording();

      // Delete the recording file if it exists
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (file.existsSync()) {
          await file.delete();
        }
      }

      _resetRecording();
      Logger().d('AudioRecordingService: Recording cancelled');
      return true;
    } catch (e) {
      Logger().e('AudioRecordingService: Failed to cancel recording - $e');
      return false;
    }
  }

  /// Check if currently recording
  bool get isRecording => _currentState == RecordingState.recording;

  /// Check if currently paused
  bool get isPaused => _currentState == RecordingState.paused;

  /// Check if in error state
  bool get hasError => _currentState == RecordingState.error;

  /// Generate a unique recording file path
  Future<String> _generateRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/recording_$timestamp.m4a';
  }

  /// Configure audio session for background recording (iOS)
  Future<void> _configureAudioSession() async {
    if (Platform.isIOS) {
      try {
        await SystemChannels.platform.invokeMethod('configureAudioSession');
      } catch (e) {
        Logger().e(
          'AudioRecordingService: Failed to configure audio session - $e',
        );
      }
    }
  }

  /// Update the recording state
  void _updateState(RecordingState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _stateController.add(newState);
    }
  }

  /// Start the duration timer
  void _startTimer() {
    _timer?.cancel();

    // Record when we start/resume recording
    _recordingStartTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Calculate total elapsed time:
      // current session + any previous paused duration
      final currentSessionDuration = DateTime.now().difference(
        _recordingStartTime!,
      );
      _recordingDuration = _pausedDuration + currentSessionDuration;
      _durationController.add(_recordingDuration);
    });
  }

  /// Stop the duration timer
  void _stopTimer() {
    if (_timer != null && _recordingStartTime != null) {
      // When stopping/pausing, accumulate the elapsed time
      final currentSessionDuration = DateTime.now().difference(
        _recordingStartTime!,
      );
      _pausedDuration = _pausedDuration + currentSessionDuration;
      _recordingDuration = _pausedDuration;
    }

    _timer?.cancel();
    _timer = null;
    _recordingStartTime = null;
  }

  /// Reset recording state
  void _resetRecording() {
    _recordingDuration = Duration.zero;
    _pausedDuration = Duration.zero;
    _recordingStartTime = null;
    _currentRecordingPath = null;
    _durationController.add(_recordingDuration);
  }

  /// Dispose resources
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _stateController.close();
    _durationController.close();
  }
}
