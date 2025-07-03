import 'package:flutter/material.dart';

class PRFTheme {
  PRFTheme._();

  static const int primaryColor = 0xff17154c;
  static const int secondaryColor = 0xff93d500;
  static const int errorColor = 0xff78251b;
  static const int surfaceColor = 0xfff8f9fa;
  static const int onSurfaceVariant = 0xff6c757d;
  static const int outline = 0xffdee2e6;
  static const int shadow = 0x1f000000;
  static const int successColor = 0xff28a745;
  static const int warningColor = 0xffffc107;
  static const int infoColor = 0xff17a2b8;

  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(primaryColor),
    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme(
      primary: Color(primaryColor),
      secondary: Color(secondaryColor),
      surface: Colors.white,
      surfaceContainerHighest: Color(surfaceColor),
      error: Color(errorColor),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onSurfaceVariant: Color(onSurfaceVariant),
      onError: Colors.white,
      outline: Color(outline),
      shadow: Color(shadow),
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(primaryColor),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(primaryColor),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(
          primaryColor,
        ).withValues(alpha: 0.4),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        shadowColor: const Color(shadow),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(primaryColor),
        side: const BorderSide(color: Color(primaryColor), width: 1.5),
        disabledForegroundColor: const Color(
          primaryColor,
        ).withValues(alpha: 0.4),
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(primaryColor),
        disabledForegroundColor: const Color(
          primaryColor,
        ).withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(surfaceColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(outline)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(outline)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(primaryColor), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(errorColor)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(errorColor), width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: const Color(outline).withValues(alpha: 0.5),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    cardTheme: CardThemeData(
      elevation: 3,
      shadowColor: const Color(shadow),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),

    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: Color(outline),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(primaryColor),
      linearTrackColor: Color(outline),
      circularTrackColor: Color(outline),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(surfaceColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(outline)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(primaryColor), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(errorColor)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    ),

    iconTheme: const IconThemeData(
      color: Color(primaryColor),
      size: 24,
    ),

    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      indicatorColor: const Color(primaryColor),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: const Color(primaryColor),
      unselectedLabelColor: const Color(onSurfaceVariant),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),

    dataTableTheme: DataTableThemeData(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(outline)),
      ),
      headingRowColor: WidgetStateProperty.all(const Color(surfaceColor)),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor).withValues(alpha: 0.1);
        }
        return Colors.white;
      }),
      dividerThickness: 1,
      horizontalMargin: 16,
      columnSpacing: 24,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(surfaceColor),
      selectedColor: const Color(primaryColor),
      disabledColor: const Color(outline),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor);
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor).withValues(alpha: 0.3);
        }
        return const Color(outline);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor);
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: Color(outline), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor);
        }
        return const Color(outline);
      }),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(primaryColor),
      unselectedItemColor: Color(onSurfaceVariant),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(primaryColor).withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Color(primaryColor),
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(color: Color(onSurfaceVariant));
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(primaryColor));
        }
        return const IconThemeData(color: Color(onSurfaceVariant));
      }),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(primaryColor),
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      surfaceTintColor: Colors.transparent,
    ),

    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Color(surfaceColor),
      collapsedBackgroundColor: Colors.white,
      iconColor: Color(primaryColor),
      collapsedIconColor: Color(onSurfaceVariant),
      textColor: Colors.black,
      collapsedTextColor: Colors.black,
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
    ),

    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color(surfaceColor),
      contentTextStyle: TextStyle(color: Colors.black),
      elevation: 2,
    ),

    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      dialBackgroundColor: const Color(surfaceColor),
      hourMinuteColor: const Color(primaryColor).withValues(alpha: 0.1),
      hourMinuteTextColor: const Color(primaryColor),
      dayPeriodColor: const Color(primaryColor).withValues(alpha: 0.1),
      dayPeriodTextColor: const Color(primaryColor),
      dialHandColor: const Color(primaryColor),
      dialTextColor: Colors.black,
      entryModeIconColor: const Color(primaryColor),
      helpTextStyle: const TextStyle(color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: const Color(primaryColor),
      headerForegroundColor: Colors.white,
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor);
        }
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
      todayForegroundColor: WidgetStateProperty.all(const Color(primaryColor)),
      todayBorder: const BorderSide(color: Color(primaryColor), width: 2),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(primaryColor);
        }
        return Colors.transparent;
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
