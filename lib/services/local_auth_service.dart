import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<(bool, String?)> authenticateLocally() async {
    try {
      final result = await localAuth.authenticate(
        localizedReason: 'We need to protect your giving history.',
      );

      return (result, null);
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricHardware) {
        return (
          false,
          e.description ??
              'Biometric authentication is not available on this device.',
        );
      } else if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        return (
          false,
          e.description ?? 'No biometrics are enrolled on this device.',
        );
      } else {
        return (false, e.description ?? 'Authentication failed.');
      }
    }
  }
}
