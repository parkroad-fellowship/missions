import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

/// Helper that takes numbered screenshots via the render tree.
///
/// Screenshots are saved as PNG files to a `screenshots/` folder.
/// Pass the project root via `--dart-define=PROJECT_DIR=...` so screenshots
/// land in `<project>/screenshots/`. Falls back to the system temp directory.
class ScreenshotHelper {
  ScreenshotHelper(this.$);

  final PatrolIntegrationTester $;
  int _counter = 0;
  Directory? _screenshotDir;

  /// Takes a screenshot after pumping for [settle] to let the page render.
  ///
  /// Uses `$.pump` instead of `pumpAndSettle` because the app
  /// contains repeating `flutter_animate` animations (e.g. the pulsing avatar
  /// on the landing page) which would cause `pumpAndSettle` to time out.
  Future<void> take(
    String name, {
    Duration settle = const Duration(seconds: 1),
  }) async {
    await $.pump(settle);
    _counter++;
    final fileName = '${_counter.toString().padLeft(2, '0')}_$name';

    final renderView = $.tester.binding.renderViews.first;
    final layer = renderView.debugLayer! as OffsetLayer;
    final image = await layer.toImage(renderView.paintBounds);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    _screenshotDir ??= _getScreenshotDir();
    File('${_screenshotDir!.path}/$fileName.png')
        .writeAsBytesSync(bytes!.buffer.asUint8List());
    log('Screenshot saved: ${_screenshotDir!.path}/$fileName.png');
  }

  Directory _getScreenshotDir() {
    const projectDir = String.fromEnvironment('PROJECT_DIR');
    if (projectDir.isNotEmpty) {
      final dir = Directory('$projectDir/screenshots');
      if (!dir.existsSync()) dir.createSync(recursive: true);
      return dir;
    }
    // Fallback when PROJECT_DIR is not set (e.g. running `patrol test`
    // directly without `--dart-define=PROJECT_DIR=...`).
    // Use the system temp directory which is always writable.
    final dir = Directory('${Directory.systemTemp.path}/screenshots');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    log('PROJECT_DIR not set — saving screenshots to: ${dir.path}');
    log('Run via "make screenshots" to save to the project folder.');
    return dir;
  }
}
