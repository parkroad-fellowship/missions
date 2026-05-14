import 'dart:async';

import 'package:app/di/_index.dart';
import 'package:app/services/audio_playback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:prf_design/prf_design.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    required this.url,
    this.title,
    this.transcript,
    super.key,
  });

  final String url;
  final String? title;
  final String? transcript;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlaybackService _playback = getIt<AudioPlaybackService>();

  AudioSource? _source;
  SoundHandle? _handle;
  Timer? _ticker;

  Duration _position = Duration.zero;
  Duration _length = Duration.zero;

  bool _isLoading = false;
  bool _isPlaying = false;

  @override
  void dispose() {
    _ticker?.cancel();
    final handle = _handle;
    if (handle != null) {
      _playback.stop(handle);
    }
    final source = _source;
    if (source != null) {
      _playback.disposeSource(source);
    }
    super.dispose();
  }

  String _format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startTicker() {
    _ticker?.cancel();
    final handle = _handle;
    if (handle == null) return;

    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() {
        _position = _playback.getPosition(handle);
      });
    });
  }

  Future<void> _togglePlay() async {
    if (_isLoading) return;

    final handle = _handle;
    if (handle != null) {
      final paused = _playback.isPaused(handle);
      _playback.setPaused(handle, paused: !paused);
      setState(() => _isPlaying = paused);
      if (paused) {
        _startTicker();
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _position = Duration.zero;
    });

    try {
      final source = await _playback.loadUrl(widget.url);
      final newHandle = await _playback.play(source);
      final length = _playback.getLength(source);

      if (!mounted) return;
      setState(() {
        _source = source;
        _handle = newHandle;
        _length = length;
        _isPlaying = true;
      });
      _startTicker();
    } catch (_) {
      if (!mounted) return;
      PRFSnackbar.error(context, 'Unable to play audio');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _seek(double value) {
    final handle = _handle;
    if (handle == null) return;
    final target = Duration(milliseconds: value.round());
    _playback.seek(handle, target);
    setState(() => _position = target);
  }

  Future<void> _viewTranscript() async {
    final transcript = widget.transcript;
    if (transcript == null || transcript.trim().isEmpty) return;

    await PRFBottomSheet.show<void>(
      context,
      title: 'Transcript',
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          child: Text(
            transcript,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transcript = widget.transcript;
    final hasTranscript = transcript != null && transcript.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
          ],
          Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: PRFCircularProgressIndicator(),
                      )
                    : Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
              ),
              const SizedBox(width: PRFSpacingTokens.sm),
              Expanded(
                child: Column(
                  children: [
                    Slider(
                      value: _position.inMilliseconds
                          .clamp(0, _length.inMilliseconds)
                          .toDouble(),
                      max:
                          (_length.inMilliseconds == 0
                                  ? 1
                                  : _length.inMilliseconds)
                              .toDouble(),
                      onChanged: _length.inMilliseconds == 0 ? null : _seek,
                    ),
                    Row(
                      children: [
                        Text(
                          _format(_position),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          _format(_length),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (hasTranscript) ...[
                const SizedBox(width: PRFSpacingTokens.sm),
                IconButton(
                  onPressed: _viewTranscript,
                  icon: const Icon(Icons.article_outlined),
                  tooltip: 'Transcript',
                ),
              ],
            ],
          ),
          if (hasTranscript) ...[
            const SizedBox(height: PRFSpacingTokens.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PRFSpacingTokens.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: 0.05,
                ),
                borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
              ),
              child: Text(
                transcript,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
