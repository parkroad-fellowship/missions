import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PRFTextTheme {
  PRFTextTheme._();

  static TextTheme getLightTheme(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet =
        screenWidth >= 600; // Material Design breakpoint for tablets

    // Use different base widths for tablet and phone
    final baseWidth =
        isTablet ? 600.0 : 375.0; // 600 for tablets, 375 for phones (iPhone SE)
    final scaleFactor = screenWidth / baseWidth;

    // Different scale ranges for tablet and phone
    final adjustedScaleFactor = scaleFactor.clamp(
      isTablet ? 0.8 : 0.8, // Minimum scale
      isTablet ? 1.6 : 1.4, // Maximum scale - slightly larger for tablets
    ); // Limit scaling range

    const defaultTextColor = Colors.black;

    return GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.lato(
        fontSize: 24 * adjustedScaleFactor,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 20 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 18 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
      ),
      headlineLarge: GoogleFonts.lato(
        fontSize: 20 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 15 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 16 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
      ),
      titleMedium: GoogleFonts.lato(fontSize: 11 * adjustedScaleFactor),
      titleSmall: GoogleFonts.lato(
        fontSize: 10 * adjustedScaleFactor,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 18 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 8 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
      ),
    );
  }
}
