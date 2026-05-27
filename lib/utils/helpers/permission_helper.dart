import 'package:app/di/di_container.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';

/// Permission checking utilities.
class PermissionHelper {
  // Private constructor to prevent instantiation
  PermissionHelper._();

  /// Check if the current user has a specific permission
  static bool userCan(String permission) {
    try {
      final user = getIt<HiveService>().auth.retrieveProfile();
      if (user == null) return false;

      // Cache user permissions for better performance
      final userPermissions = user.roles
          .expand((role) => role.permissions)
          .map((permission) => permission.name)
          .toSet();

      return userPermissions.contains(permission);
    } catch (e) {
      return false;
    }
  }
}
