import 'dart:io';

import 'package:app/enums/error_severity.dart';
import 'package:app/enums/error_type.dart';

/// Enhanced Failure class for comprehensive error handling.
///
/// Example usage:
/// ```dart
/// throw Failure(
///   message: 'Failed to fetch user data',
///   statusCode: 404,
///   type: ErrorType.notFound,
///   severity: ErrorSeverity.medium,
///   technicalMessage: 'GET /api/users/123 returned 404',
/// );
/// ```
class Failure implements Exception {
  Failure({
    required this.message,
    this.statusCode,
    this.type = ErrorType.unknown,
    this.severity = ErrorSeverity.medium,
    this.technicalMessage,
    this.isRecoverable = true,
    this.stackTrace,
    this.context = const {},
  });

  /// Create a Failure from an HTTP status code.
  factory Failure.fromStatusCode(
    int statusCode,
    String message, [
    StackTrace? stackTrace,
  ]) {
    final type = _typeFromStatusCode(statusCode);
    final severity = _severityFromStatusCode(statusCode);
    final isRecoverable = statusCode < 500;

    return Failure(
      message: message,
      statusCode: statusCode,
      type: type,
      severity: severity,
      isRecoverable: isRecoverable,
      stackTrace: stackTrace,
    );
  }

  /// Create a Failure from a generic exception.
  factory Failure.fromException(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    if (error is SocketException) {
      return Failure.noConnection(stackTrace: stackTrace);
    }

    if (error is HttpException) {
      return Failure(
        message: 'Network request failed',
        type: ErrorType.network,
        severity: ErrorSeverity.high,
        technicalMessage: error.message,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return Failure(
        message: 'Invalid data format',
        type: ErrorType.validation,
        technicalMessage: error.message,
        stackTrace: stackTrace,
      );
    }

    return Failure(
      message: error.toString(),
      stackTrace: stackTrace,
    );
  }

  /// Create a Failure for no network connection.
  factory Failure.noConnection({StackTrace? stackTrace}) {
    return Failure(
      message: 'No internet connection. Please check your network settings.',
      type: ErrorType.network,
      severity: ErrorSeverity.high,
      stackTrace: stackTrace,
    );
  }

  /// Create a Failure for timeout.
  factory Failure.timeout({StackTrace? stackTrace}) {
    return Failure(
      message: 'Request timed out. Please try again.',
      type: ErrorType.timeout,
      stackTrace: stackTrace,
    );
  }

  /// Create a Failure for authentication errors.
  factory Failure.authentication({
    String message = 'Authentication failed. Please sign in again.',
    StackTrace? stackTrace,
  }) {
    return Failure(
      message: message,
      statusCode: 401,
      type: ErrorType.authentication,
      severity: ErrorSeverity.high,
      stackTrace: stackTrace,
    );
  }

  /// Create a Failure for authorization errors.
  factory Failure.authorization({
    String message = 'You do not have permission to perform this action.',
    StackTrace? stackTrace,
  }) {
    return Failure(
      message: message,
      statusCode: 403,
      type: ErrorType.authorization,
      isRecoverable: false,
      stackTrace: stackTrace,
    );
  }

  /// User-friendly error message suitable for display.
  final String message;

  /// HTTP status code, if applicable.
  final int? statusCode;

  /// Type of error for categorization.
  final ErrorType type;

  /// Severity level for logging/alerting.
  final ErrorSeverity severity;

  /// Technical details for debugging (not shown to users).
  final String? technicalMessage;

  /// Whether the user can recover from this error (e.g., retry).
  final bool isRecoverable;

  /// Stack trace for debugging.
  final StackTrace? stackTrace;

  /// Additional context data for debugging.
  final Map<String, dynamic> context;

  static ErrorType _typeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ErrorType.validation;
      case 401:
        return ErrorType.authentication;
      case 403:
        return ErrorType.authorization;
      case 404:
        return ErrorType.notFound;
      case 408:
        return ErrorType.timeout;
      case >= 500:
        return ErrorType.server;
      default:
        return ErrorType.unknown;
    }
  }

  static ErrorSeverity _severityFromStatusCode(int statusCode) {
    if (statusCode >= 500) return ErrorSeverity.critical;
    if (statusCode == 401 || statusCode == 403) return ErrorSeverity.high;
    return ErrorSeverity.medium;
  }

  /// Create a copy of this Failure with updated fields.
  Failure copyWith({
    String? message,
    int? statusCode,
    ErrorType? type,
    ErrorSeverity? severity,
    String? technicalMessage,
    bool? isRecoverable,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return Failure(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      technicalMessage: technicalMessage ?? this.technicalMessage,
      isRecoverable: isRecoverable ?? this.isRecoverable,
      stackTrace: stackTrace ?? this.stackTrace,
      context: context ?? this.context,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('Failure: $message');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    if (technicalMessage != null) {
      buffer.write('\nTechnical: $technicalMessage');
    }
    return buffer.toString();
  }
}
