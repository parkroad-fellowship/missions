import 'dart:io';

import 'package:app/enums/common/prf_supported_platform.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart' show BuildContext, MediaQuery;
import 'package:logger/logger.dart';

/// Device type enumeration
enum DeviceType {
  phone,
  tablet,
  desktop,
}

/// Device-related utilities.
class DeviceHelper {
  // Private constructor to prevent instantiation
  DeviceHelper._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get scale factor based on device type and screen size
  static double getScaleFactor(
    BuildContext context, {
    double? customBaseWidth,
    double? minScale,
    double? maxScale,
  }) {
    try {
      final screenWidth = MediaQuery.of(context).size.width;
      final deviceType = getDeviceType(context);

      // Dynamic base widths based on device type
      final baseWidth =
          customBaseWidth ??
          switch (deviceType) {
            DeviceType.phone => 375.0,
            DeviceType.tablet => 600.0,
            DeviceType.desktop => 1200.0,
          };

      final scaleFactor = screenWidth / baseWidth;

      // Dynamic scale ranges based on device type
      final minScaleValue =
          minScale ??
          switch (deviceType) {
            DeviceType.phone => 0.8,
            DeviceType.tablet => 0.7,
            DeviceType.desktop => 0.6,
          };

      final maxScaleValue =
          maxScale ??
          switch (deviceType) {
            DeviceType.phone => 1.4,
            DeviceType.tablet => 1.6,
            DeviceType.desktop => 2.0,
          };

      return scaleFactor.clamp(minScaleValue, maxScaleValue);
    } catch (e) {
      return 1;
    }
  }

  /// Get device type based on screen size
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) return DeviceType.desktop;
    if (screenWidth >= 600) return DeviceType.tablet;
    return DeviceType.phone;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  /// Get current platform type
  static Future<PRFSupportedPlatform> getCurrentPlatform() async {
    if (Platform.isIOS) {
      return PRFSupportedPlatform.ios;
    } else if (Platform.isAndroid) {
      return await _isHuaweiDevice()
          ? PRFSupportedPlatform.huawei
          : PRFSupportedPlatform.android;
    }
    return PRFSupportedPlatform.unknown;
  }

  static Future<bool> _isHuaweiDevice() async {
    try {
      if (Platform.isAndroid) {
        return _checkHuaweiManufacturer();
      }
      return false;
    } catch (e) {
      Logger().e('Error checking Huawei device: $e');
      return false;
    }
  }

  static Future<bool> _checkHuaweiManufacturer() async {
    try {
      final androidInfo = _deviceInfo.androidInfo;

      return await androidInfo
          .then((info) {
            final manufacturer = info.manufacturer.toLowerCase();
            final brand = info.brand.toLowerCase();

            return manufacturer.contains('huawei') ||
                manufacturer.contains('honor') ||
                brand.contains('huawei') ||
                brand.contains('honor');
          })
          .catchError((Object e) {
            Logger().e('Error getting Android info: $e');
            return false;
          });
    } catch (e) {
      return false;
    }
  }
}
