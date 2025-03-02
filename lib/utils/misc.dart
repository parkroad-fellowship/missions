import 'dart:math';

import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/versioning/build_version.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' show BuildContext, MediaQuery, Size;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:slugify/slugify.dart' as slugify;
import 'package:url_launcher/url_launcher.dart';

class Misc {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime.toLocal());
  }

  static String formatMissionDate(DateTime dateTime) =>
      DateFormat.EEEE().add_yMMMd().format(dateTime.toLocal());

  static String formatDate(DateTime dateTime) =>
      DateFormat.yMMMMd().format(dateTime.toLocal());

  static String formatTime(String time) =>
      DateFormat.jm().format(DateTime.parse('2012-02-27 $time'));
  static String formatTimeFromDateTime(DateTime dateTime) =>
      DateFormat.jm().format(dateTime);

  static String getUserNameInitials(String userName) {
    final trimmedName = userName.trim();
    var initials = 'U';
    if (trimmedName.isNotEmpty) {
      final index = trimmedName.indexOf(' ');
      initials = trimmedName[0].toUpperCase();
      if (index != -1) {
        initials = initials + trimmedName[index + 1].toUpperCase();
      }
    }
    return initials;
  }

  static double truncateToDecimalPlaces(double value, int fractionalDigits) =>
      (value * pow(10, fractionalDigits)).truncate() /
      pow(10, fractionalDigits);

  static String getFullAppVersion() {
    return packageVersion.trim();
  }

  static String getAppVersion() {
    return packageVersion.replaceRange(7, packageVersion.length, '');
  }

  static String getSluggedAppVersion() {
    return slugify.slugify(getAppVersion());
  }

  static bool memberHasSubscribed(PRFMission mission) {
    return mission.loggedInMemberMissionSubscription != null &&
        (mission.loggedInMemberMissionSubscription!.status ==
                PRFMissionSubscriptionStatus.approved ||
            mission.loggedInMemberMissionSubscription!.status ==
                PRFMissionSubscriptionStatus.pending);
  }

  static bool canSubscribeToMission(PRFMission mission) {
    return mission.status == PRFMissionStatus.approved &&
        mission.missionSubscriptionsNeeded > 0;
  }

  static void initDimensions(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1290, 2796));
  }

  static bool userCan(String permission) {
    final user = getIt<HiveService>().retrieveProfile();
    if (user == null) return false;

    // Get the permissions from the role key
    // Flatten the permissions from all the roles
    // Check if the permission exists for the user across all the roles
    final permissionFound = user.roles
        .map((role) => role.permissions)
        .toList()
        .flattened
        .toSet()
        .firstWhereOrNull(
          (permissionEntry) => permissionEntry.name == permission,
        );

    if (permissionFound == null) return false;
    return true;
  }

  static Future<void> openUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static String getFileName(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }

  static String formatCash(int amount) => NumberFormat.currency(
    locale: 'en_KE',
    symbol: '',
    decimalDigits: 0,
  ).format(amount);

  static double getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet =
        screenWidth >= 600; // Material Design breakpoint for tablets

    // Use different base widths for tablet and phone
    final baseWidth =
        isTablet ? 600.0 : 375.0; // 600 for tablets, 375 for phones (iPhone SE)
    final scaleFactor = screenWidth / baseWidth;

    // Different scale ranges for tablet and phone
    return scaleFactor.clamp(
      isTablet ? 0.8 : 0.8, // Minimum scale
      isTablet ? 1.6 : 1.4, // Maximum scale - slightly larger for tablets
    ); // Limit scaling range
  }
}
