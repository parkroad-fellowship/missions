import 'package:app/enums/error_type.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/shared_widgets/buttons/primary/primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that displays an error state with an optional retry action.
class PRFErrorView extends StatelessWidget {
  const PRFErrorView({
    required this.failure,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  /// Create an error view from a message string.
  factory PRFErrorView.fromMessage({
    required String message,
    VoidCallback? onRetry,
    bool compact = false,
    Key? key,
  }) {
    return PRFErrorView(
      failure: Failure(message: message),
      onRetry: onRetry,
      compact: compact,
      key: key,
    );
  }

  final Failure failure;
  final VoidCallback? onRetry;
  final bool compact;

  IconData get _icon {
    switch (failure.type) {
      case ErrorType.network:
        return Icons.wifi_off_outlined;
      case ErrorType.authentication:
        return Icons.lock_outline;
      case ErrorType.authorization:
        return Icons.block_outlined;
      case ErrorType.validation:
        return Icons.warning_amber_outlined;
      case ErrorType.notFound:
        return Icons.search_off_outlined;
      case ErrorType.server:
        return Icons.cloud_off_outlined;
      case ErrorType.timeout:
        return Icons.timer_off_outlined;
      case ErrorType.cancelled:
        return Icons.cancel_outlined;
      case ErrorType.unknown:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return _buildCompact(theme);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
            const SizedBox(height: 16),
            Text(
              _getTitle(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
            if (failure.isRecoverable && onRetry != null) ...[
              const SizedBox(height: 24),
              PRFPrimaryButton(
                onPressed: onRetry!,
                title: 'Try Again',
                disabled: false,
              ).animate().fadeIn(delay: 500.ms).scale(delay: 100.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _icon,
              size: 24,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getTitle(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  failure.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (failure.isRecoverable && onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (failure.type) {
      case ErrorType.network:
        return 'Connection Error';
      case ErrorType.authentication:
        return 'Authentication Required';
      case ErrorType.authorization:
        return 'Access Denied';
      case ErrorType.validation:
        return 'Invalid Input';
      case ErrorType.notFound:
        return 'Not Found';
      case ErrorType.server:
        return 'Server Error';
      case ErrorType.timeout:
        return 'Request Timeout';
      case ErrorType.cancelled:
        return 'Request Cancelled';
      case ErrorType.unknown:
        return 'Something Went Wrong';
    }
  }
}
