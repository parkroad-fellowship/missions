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

    return GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.lato(
        fontSize: 24 * adjustedScaleFactor,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        color: Colors.black,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 20 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 18 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 15 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
      ),
      titleMedium: GoogleFonts.lato(fontSize: 11 * adjustedScaleFactor),
      titleSmall: GoogleFonts.lato(
        fontSize: 10 * adjustedScaleFactor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 18 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 8 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: GoogleFonts.lato(
        fontSize: 20 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
