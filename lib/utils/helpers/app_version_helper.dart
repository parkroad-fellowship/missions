import 'package:app/utils/slugify.dart' as slugify;
import 'package:app/versioning/build_version.dart';

/// App version utilities.
class AppVersionHelper {
  // Private constructor to prevent instantiation
  AppVersionHelper._();

  /// Get full app version string
  static String getFullAppVersion() {
    try {
      return packageVersion.trim();
    } catch (e) {
      return '0.0.0';
    }
  }

  /// Get shortened app version string (max 7 characters)
  static String getAppVersion() {
    try {
      final version = packageVersion.trim();
      return version.length > 7 ? version.substring(0, 7) : version;
    } catch (e) {
      return '0.0.0';
    }
  }

  /// Get slugified app version for use in file names/paths
  static String getSluggedAppVersion() {
    try {
      return slugify.slugify(getAppVersion());
    } catch (e) {
      return '0-0-0';
    }
  }
}
