import 'package:url_launcher/url_launcher.dart';

/// URL handling utilities.
class UrlHelper {
  // Private constructor to prevent instantiation
  UrlHelper._();

  /// Open a URL in an external application
  static Future<bool> openUrl(
    Uri uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
