import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text;
import 'package:flutter/services.dart';

/// Navigation and app lifecycle utilities.
class NavigationHelper {
  // Private constructor to prevent instantiation
  NavigationHelper._();

  // Static variable to track last back press across all instances
  static DateTime? _lastBackPressed;

  /// Handle back button press with double-tap-to-exit behavior
  static void exitApp({
    required BuildContext context,
    required bool didPop,
    required Object? result,
    String? exitMessage,
    Duration? timeWindow,
  }) {
    if (didPop) return;

    final now = DateTime.now();
    final window = timeWindow ?? const Duration(seconds: 2);
    final message = exitMessage ?? 'Press back again to exit';

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > window) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: window,
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }
}
