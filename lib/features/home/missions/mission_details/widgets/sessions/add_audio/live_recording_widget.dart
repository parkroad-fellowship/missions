import 'dart:io';

import 'package:app/features/home/missions/cubit/audio_recording_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveRecordingWidget extends StatefulWidget {
  const LiveRecordingWidget({
    required this.onRecordingCompleted,
    super.key,
  });

  final void Function(String filePath, Duration duration) onRecordingCompleted;

  @override
  State<LiveRecordingWidget> createState() => _LiveRecordingWidgetState();
}

class _LiveRecordingWidgetState extends State<LiveRecordingWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize pulse animation for recording button

    // Initialize wave animation for active recording
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _waveAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _waveController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AudioRecordingCubit, AudioRecordingState>(
      listener: (context, state) {
        state.when(
          initial: () {
            _waveController.stop();
          },
          ready: () {
            _waveController.stop();
          },
          recording: (duration) {
            _waveController.repeat(reverse: true);
          },
          paused: (duration) {
            _waveController.stop();
          },
          completed: (filePath, duration) {
            _waveController.stop();
            widget.onRecordingCompleted(filePath, duration);
          },
          error: (message) {
            _waveController.stop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: state.when(
            initial: () => const Center(
              child: PRFCircularProgressIndicator(),
            ),
            ready: () => _buildReadyState(context, l10n),
            recording: (duration) =>
                _buildRecordingState(context, l10n, duration),
            paused: (duration) => _buildPausedState(context, l10n, duration),
            completed: (filePath, duration) =>
                _buildCompletedState(context, l10n, filePath, duration),
            error: (message) => _buildErrorState(context, l10n, message),
          ),
        );
      },
    );
  }

  Widget _buildReadyState(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mic,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.tapToStartRecording,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.recordingWillContinueInBackground,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () => context.read<AudioRecordingCubit>().startRecording(),
          icon: const Icon(Icons.fiber_manual_record),
          label: Text(l10n.startRecording),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingState(
    BuildContext context,
    AppLocalizations l10n,
    Duration duration,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Wave animation
        SizedBox(
          height: 60,
          child: AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final delay = index * 0.2;
                  final animationValue = (_waveAnimation.value + delay) % 1.0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 20 + (animationValue * 40),
                    width: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Recording duration
        Text(
          _formatDuration(duration),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.error,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          l10n.liveRecording,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: 32),

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pause button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().pauseRecording(),
                icon: const Icon(Icons.pause),
                label: Text(l10n.pause),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            SizedBox(width: 16),

            // Stop button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().stopRecording(),
                icon: const Icon(Icons.stop),
                label: Text(l10n.stop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPausedState(
    BuildContext context,
    AppLocalizations l10n,
    Duration duration,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pause,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          _formatDuration(duration),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          l10n.recordingPaused,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: 32),

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Resume button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().resumeRecording(),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.resume),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Stop button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().stopRecording(),
                icon: const Icon(Icons.stop),
                label: Text(l10n.stop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedState(
    BuildContext context,
    AppLocalizations l10n,
    String filePath,
    Duration duration,
  ) {
    final file = File(filePath);
    final fileName = file.path.split('/').last;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          l10n.recordingCompleted,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.audiotrack,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Duration: ${_formatDuration(duration)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () => context.read<AudioRecordingCubit>().resetRecording(),
          icon: const Icon(Icons.refresh),
          label: Text(l10n.recordAnother),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppLocalizations l10n,
    String message,
  ) {
    final isPermissionError = message.toLowerCase().contains('permission');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPermissionError ? Icons.mic_off : Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          isPermissionError ? 'Permission Required' : l10n.recordingError,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        if (isPermissionError) ...[
          ElevatedButton.icon(
            onPressed: () =>
                context.read<AudioRecordingCubit>().requestPermissions(),
            icon: const Icon(Icons.settings),
            label: Text(l10n.allow),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
        ],

        ElevatedButton.icon(
          onPressed: () => context.read<AudioRecordingCubit>().resetRecording(),
          icon: const Icon(Icons.refresh),
          label: Text(l10n.tryAgain),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPermissionError
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }
}
