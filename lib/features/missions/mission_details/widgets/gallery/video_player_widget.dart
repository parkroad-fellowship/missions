import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prf_design/prf_design.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    required this.videoUrl,
    super.key,
  });

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _isFullScreen = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _exitFullScreen();
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      _enterFullScreen();
    } else {
      _exitFullScreen();
    }
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: PRFColors.black,
        body: SafeArea(
          child: GestureDetector(
            onTap: _toggleControlsVisibility,
            child: Stack(
              children: [
                Center(child: _buildVideoPlayer()),
                if (_showControls) _buildFullScreenControls(theme),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: PRFColors.black,
      appBar: AppBar(
        backgroundColor: PRFColors.black,
        iconTheme: const IconThemeData(color: PRFColors.white),
        elevation: 0,
        title: Text(
          'Video',
          style: theme.textTheme.titleLarge?.copyWith(
            color: PRFColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: _buildVideoContent(theme),
      ),
    );
  }

  Widget _buildVideoContent(ThemeData theme) {
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PRFCircularProgressIndicator(color: PRFColors.white),
          const SizedBox(height: PRFSpacingTokens.lg),
          Text(
            'Loading video...',
            style: theme.textTheme.bodyLarge?.copyWith(color: PRFColors.white),
          ),
        ],
      );
    }

    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 64,
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Text(
              'Error loading video',
              style: theme.textTheme.titleLarge?.copyWith(
                color: PRFColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PRFSpacingTokens.xl),
            PRFButton(
              title: 'Retry',
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isLoading = true;
                });
                _initializeVideoPlayer();
              },
            ),
          ],
        ),
      );
    }

    if (_isInitialized) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _toggleControlsVisibility,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  if (_showControls) _buildVideoControls(),
                ],
              ),
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.xl),
          if (_showControls) _buildVideoControlsBar(theme),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  Widget _buildFullScreenControls(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PRFColors.black.withValues(alpha: 0.7),
              Colors.transparent,
              Colors.transparent,
              PRFColors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Top controls
            Positioned(
              top: PRFSpacingTokens.lg,
              left: PRFSpacingTokens.lg,
              right: PRFSpacingTokens.lg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _toggleFullScreen,
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      color: PRFColors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Center play/pause button
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: AnimatedOpacity(
                  opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                  duration: PRFMotionTokens.slow,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: PRFColors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: PRFColors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Bottom controls
            Positioned(
              bottom: PRFSpacingTokens.lg,
              left: PRFSpacingTokens.lg,
              right: PRFSpacingTokens.lg,
              child: Column(
                children: [
                  // Progress bar
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: theme.colorScheme.primary,
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  // Time and controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: PRFColors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: PRFColors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _controller
                                ..seekTo(Duration.zero)
                                ..pause();
                            },
                            icon: const Icon(
                              Icons.replay,
                              color: PRFColors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: PRFColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Center play/pause button
            Center(
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                duration: PRFMotionTokens.slow,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: PRFColors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: PRFColors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            // Full-screen button
            Positioned(
              top: PRFSpacingTokens.sm,
              right: PRFSpacingTokens.sm,
              child: GestureDetector(
                onTap: _toggleFullScreen,
                child: Container(
                  decoration: BoxDecoration(
                    color: PRFColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.xs),
                  ),
                  padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                  child: const Icon(
                    Icons.fullscreen,
                    color: PRFColors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoControlsBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl),
      child: Column(
        children: [
          // Progress bar
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: theme.colorScheme.primary,
              bufferedColor: Colors.white38,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          // Time indicators and controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_controller.value.position),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: PRFColors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: PRFColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller
                        ..seekTo(Duration.zero)
                        ..pause();
                    },
                    icon: const Icon(
                      Icons.replay,
                      color: PRFColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleFullScreen,
                    icon: const Icon(
                      Icons.fullscreen,
                      color: PRFColors.white,
                    ),
                  ),
                ],
              ),
              Text(
                _formatDuration(_controller.value.duration),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: PRFColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
