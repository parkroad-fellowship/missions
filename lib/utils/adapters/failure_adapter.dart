import 'package:app/enums/error_severity.dart';
import 'package:app/enums/error_type.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:prf_design/prf_design.dart';

/// Adapter extension to convert app's Failure to PRFFailure.
extension FailureAdapter on Failure {
  /// Converts this Failure to a PRFFailure for use with design system widgets.
  PRFFailure toPRFFailure() {
    return PRFFailure(
      message: message,
      statusCode: statusCode,
      type: _convertErrorType(type),
      severity: _convertErrorSeverity(severity),
      technicalMessage: technicalMessage,
      isRecoverable: isRecoverable,
      stackTrace: stackTrace,
      context: context,
    );
  }

  static PRFErrorType _convertErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return PRFErrorType.network;
      case ErrorType.authentication:
        return PRFErrorType.authentication;
      case ErrorType.authorization:
        return PRFErrorType.authorization;
      case ErrorType.validation:
        return PRFErrorType.validation;
      case ErrorType.notFound:
        return PRFErrorType.notFound;
      case ErrorType.server:
        return PRFErrorType.server;
      case ErrorType.timeout:
        return PRFErrorType.timeout;
      case ErrorType.cancelled:
        return PRFErrorType.cancelled;
      case ErrorType.unknown:
        return PRFErrorType.unknown;
    }
  }

  static PRFErrorSeverity _convertErrorSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return PRFErrorSeverity.low;
      case ErrorSeverity.medium:
        return PRFErrorSeverity.medium;
      case ErrorSeverity.high:
        return PRFErrorSeverity.high;
      case ErrorSeverity.critical:
        return PRFErrorSeverity.critical;
    }
  }
}
