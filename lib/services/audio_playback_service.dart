import 'package:flutter_soloud/flutter_soloud.dart';

class AudioPlaybackService {
  final SoLoud _soloud = SoLoud.instance;

  Future<void>? _initFuture;

  Future<void> ensureInitialized() {
    if (_soloud.isInitialized) {
      return Future.value();
    }
    _initFuture ??= _soloud.init();
    return _initFuture!;
  }

  Future<AudioSource> loadUrl(
    String url, {
    LoadMode mode = LoadMode.disk,
  }) async {
    await ensureInitialized();
    return _soloud.loadUrl(url, mode: mode);
  }

  Future<AudioSource> loadFile(
    String path, {
    LoadMode mode = LoadMode.disk,
  }) async {
    await ensureInitialized();
    return _soloud.loadFile(path, mode: mode);
  }

  Future<SoundHandle> play(
    AudioSource source, {
    double volume = 1,
    bool paused = false,
    bool looping = false,
    Duration loopingStartAt = Duration.zero,
  }) async {
    await ensureInitialized();
    return _soloud.play(
      source,
      volume: volume,
      paused: paused,
      looping: looping,
      loopingStartAt: loopingStartAt,
    );
  }

  Duration getPosition(SoundHandle handle) => _soloud.getPosition(handle);

  Duration getLength(AudioSource source) => _soloud.getLength(source);

  void seek(SoundHandle handle, Duration position) =>
      _soloud.seek(handle, position);

  bool isPaused(SoundHandle handle) => _soloud.getPause(handle);

  void setPaused(SoundHandle handle, {required bool paused}) =>
      _soloud.setPause(handle, paused);

  Future<void> stop(SoundHandle handle) => _soloud.stop(handle);

  Future<void> disposeSource(AudioSource source) => _soloud.disposeSource(source);
}
