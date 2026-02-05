import 'package:app/enums/error_severity.dart';
import 'package:app/enums/error_type.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:flutter/material.dart';

/// Helper class for showing error snackbars.
class PRFErrorSnackbar {
  // Private constructor to prevent instantiation
  PRFErrorSnackbar._();

  /// Show an error snackbar from a Failure.
  static void show(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context)
      // Clear any existing snackbars
      ..clearSnackBars();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _getIcon(failure.type),
            color: _getIconColor(theme, failure.severity),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onInverseSurface,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(theme, failure.severity),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: failure.isRecoverable && onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: theme.colorScheme.inversePrimary,
              onPressed: () {
                messenger.hideCurrentSnackBar();
                onRetry();
              },
            )
          : null,
    );

    messenger.showSnackBar(snackBar);
  }

  /// Show an error snackbar from a message string.
  static void showMessage(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      Failure(message: message),
      onRetry: onRetry,
      duration: duration,
    );
  }

  static IconData _getIcon(ErrorType type) {
    switch (type) {
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

  static Color _getBackgroundColor(ThemeData theme, ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return theme.colorScheme.surfaceContainerHighest;
      case ErrorSeverity.medium:
        return theme.colorScheme.inverseSurface;
      case ErrorSeverity.high:
        return theme.colorScheme.errorContainer;
      case ErrorSeverity.critical:
        return theme.colorScheme.error;
    }
  }

  static Color _getIconColor(ThemeData theme, ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return theme.colorScheme.onSurfaceVariant;
      case ErrorSeverity.medium:
        return theme.colorScheme.onInverseSurface;
      case ErrorSeverity.high:
        return theme.colorScheme.onErrorContainer;
      case ErrorSeverity.critical:
        return theme.colorScheme.onError;
    }
  }
}
