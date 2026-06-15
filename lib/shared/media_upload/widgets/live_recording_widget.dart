import 'dart:io';

import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/shared/media_upload/cubit/audio_recording_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class LiveRecordingWidget extends StatefulWidget {
  const LiveRecordingWidget({
    required this.onRecordingCompleted,
    this.onMinimize,
    super.key,
  });

  final void Function(String filePath, Duration duration) onRecordingCompleted;
  final VoidCallback? onMinimize;

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
            PRFSnackbar.error(context, message);
          },
        );
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.sm,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: state.when(
                  initial: () => const Center(
                    child: PRFCircularProgressIndicator(),
                  ),
                  ready: () => _buildReadyState(context, l10n),
                  recording: (duration) =>
                      _buildRecordingState(context, l10n, duration),
                  paused: (duration) =>
                      _buildPausedState(context, l10n, duration),
                  completed: (filePath, duration) => _buildCompletedState(
                    context,
                    l10n,
                    filePath,
                    duration,
                  ),
                  error: (message) => _buildErrorState(context, l10n, message),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReadyState(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
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
        const SizedBox(height: PRFSpacingTokens.xl),
        Text(
          l10n.tapToStartRecording,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
          l10n.recordingWillContinueInBackground,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        Text(
          'Recordings are saved locally and will upload when you are online.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        PRFDestroyButton(
          onPressed: () => context.read<AudioRecordingCubit>().startRecording(),
          title: l10n.startRecording,
          disabled: false,
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

        const SizedBox(height: PRFSpacingTokens.xl),

        // Recording duration
        Text(
          _formatDuration(duration),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.error,
          ),
        ),

        const SizedBox(height: PRFSpacingTokens.md),

        Text(
          l10n.liveRecording,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: PRFSpacingTokens.xxl),

        if (widget.onMinimize != null) ...[
          PRFSecondaryButton(
            onPressed: widget.onMinimize!,
            title: 'Use app while recording',
            disabled: false,
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
        ],

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pause button
            Flexible(
              child: PRFSecondaryButton(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().pauseRecording(),
                title: l10n.pause,
                disabled: false,
              ),
            ),

            const SizedBox(width: PRFSpacingTokens.lg),

            // Stop button
            Flexible(
              child: PRFPrimaryButton(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().stopRecording(),
                title: l10n.stop,
                disabled: false,
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
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
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

        const SizedBox(height: PRFSpacingTokens.xl),

        Text(
          _formatDuration(duration),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        const SizedBox(height: PRFSpacingTokens.md),

        Text(
          l10n.recordingPaused,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: PRFSpacingTokens.xxl),

        if (widget.onMinimize != null) ...[
          PRFSecondaryButton(
            onPressed: widget.onMinimize!,
            title: 'Use app while paused',
            disabled: false,
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
        ],

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Resume button
            Flexible(
              child: PRFDestroyButton(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().resumeRecording(),
                title: l10n.resume,
                disabled: false,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.lg),
            // Stop button
            Flexible(
              child: PRFPrimaryButton(
                onPressed: () =>
                    context.read<AudioRecordingCubit>().stopRecording(),
                title: l10n.stop,
                disabled: false,
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
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
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

        const SizedBox(height: PRFSpacingTokens.xl),

        Text(
          l10n.recordingCompleted,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: PRFSpacingTokens.md),

        Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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
                  const SizedBox(width: PRFSpacingTokens.sm),
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
              const SizedBox(height: PRFSpacingTokens.sm),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: PRFSpacingTokens.xs),
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

        const SizedBox(height: PRFSpacingTokens.xxl),

        PRFPrimaryButton(
          onPressed: () => context.read<AudioRecordingCubit>().resetRecording(),
          title: l10n.recordAnother,
          disabled: false,
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
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
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

        const SizedBox(height: PRFSpacingTokens.xl),

        Text(
          isPermissionError ? 'Permission Required' : l10n.recordingError,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: PRFSpacingTokens.md),

        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: PRFSpacingTokens.xxl),

        if (isPermissionError) ...[
          PRFPrimaryButton(
            onPressed: () =>
                context.read<AudioRecordingCubit>().requestPermissions(),
            title: l10n.allow,
            disabled: false,
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
        ],

        PRFPrimaryButton(
          onPressed: () => context.read<AudioRecordingCubit>().resetRecording(),
          title: l10n.tryAgain,
          disabled: false,
        ),
      ],
    );
  }
}
