import 'dart:developer';

import 'package:app/app/app.dart';
import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_environment.dart';
import 'package:app/firebase_options.dart';
import 'package:app/services/analytics/_analytics_service.dart';
import 'package:app/services/firebase/firebase_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:patrol/patrol.dart';
import 'package:prf_design/prf_design.dart' show PRFPrimaryButton;
import 'package:timezone/data/latest.dart' as tz_data;

import 'utils/screenshot_helper.dart';
import 'utils/test_config.dart';

void main() {
  patrolTest(
    'Screenshot every page',
    config: const PatrolTesterConfig(
      // The app has infinite flutter_animate animations that prevent
      // pumpAndSettle from ever completing.
      settlePolicy: SettlePolicy.noSettle,
    ),
    ($) async {
      // ── Real rendering so animations and images display correctly ──
      ($.tester.binding as LiveTestWidgetsFlutterBinding).framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

      // Use Flutter's native tester for direct taps (bypasses Patrol's
      // waitUntilVisible which times out with infinite animations).
      final tester = $.tester;
      final screenshots = ScreenshotHelper($);

      // ──────────────────────────────────────────────────────────────
      // 1. Bootstrap – mirrors main_development.dart + bootstrap.dart
      // ──────────────────────────────────────────────────────────────
      PRFSuperAppConfig(
        values: PRFSuperAppValues(
          environment: PRFEnvironment.development,
          hiveBox: 'prf-super-app-dev',
          baseDomain: 'dev.api.parkroadfellowship.org',
          urlScheme: 'https',
          // socketDomain: 'dev.ws.parkroadfellowship.org',
          // socketKey: 'yvnlkaqadqiadutrs9sa',
          // socketScheme: 'wss',
          // socketPort: 443,
          azureConnString:
              'DefaultEndpointsProtocol=https;AccountName=prfcorestorage;'
              'AccountKey=oizfzMYG6gsjQWTfix8V/50Jh40qCg93DzNiFok/DxJjDOhffzM0'
              'TA4TNOV4TYqU1QONfaQOrrs7+ASteXMXPA==;'
              'EndpointSuffix=core.windows.net',
          appId: 'prf_missions_01khyfbrbnaqq8tjdcvjjnvv78',
          appSecret:
              // ignore: lines_longer_than_80_chars
              'lXmRrcK3R1yJMs1r9iZ1omYdnHaUhJtdnwQO2Kz61mHH6T7SVC6ZyNShRKGcybOh',
        ),
      );

      // Bloc observer
      Bloc.observer = const _SilentBlocObserver();

      // Licences
      LicenseRegistry.addLicense(() async* {
        final license = await rootBundle.loadString(
          'assets/google_fonts/OFL.txt',
        );
        yield LicenseEntryWithLineBreaks(['google_fonts'], license);
      });

      tz_data.initializeTimeZones();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await Future<dynamic>.delayed(const Duration(milliseconds: 100));

      DIContainer.setup();
      await DIContainer.initializeDatabases();

      try {
        await getIt<PRFFirebaseService>().initRemoteConfig();
      } catch (e) {
        Logger().e(e);
      }

      await getIt<AnalyticsService>().init();

      await getIt<MediaService>().initDownloader();

      // ── Launch the app ──
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: DIContainer.registerCubits(),
          child: const PRFSuperApp(),
        ),
      );

      // Wait for DecisionRoute to resolve and redirect.
      await tester.pump(TestConfig.pageLoadWait);

      // ──────────────────────────────────────────────────────────────
      // 2. Sign In
      // ──────────────────────────────────────────────────────────────
      // If we landed on the sign-in page, screenshot it and tap Sign In.
      // Credentials are pre-filled in debug mode (kDebugMode).
      if (_isOnPage(tester, 'Sign In')) {
        await screenshots.take('sign_in');

        // Tap the PRFPrimaryButton (Sign In button).
        final signInButton = find.byType(PRFPrimaryButton);
        if (signInButton.evaluate().isNotEmpty) {
          await tester.tap(signInButton.first);
          await tester.pump(TestConfig.signInWait);
        }
      }

      // ──────────────────────────────────────────────────────────────
      // 3. Landing page
      // ──────────────────────────────────────────────────────────────

      // Dismiss the "Get Notified!" notification permission dialog if present.
      final denyButton = find.text('Deny');
      if (denyButton.evaluate().isNotEmpty) {
        await tester.tap(denyButton.first);
        await tester.pump(TestConfig.shortWait);
      }

      await screenshots.take('landing');

      // Scroll down to capture remaining action cards.
      await _scrollDown(tester);
      await screenshots.take('landing_scrolled');

      // Scroll back to top.
      await _scrollToTop(tester);

      // ──────────────────────────────────────────────────────────────
      // 4. Account page – tap the profile avatar
      // ──────────────────────────────────────────────────────────────
      final avatarArea = find.byIcon(Icons.person);
      if (avatarArea.evaluate().isEmpty) {
        // The avatar might be an image; try tapping the first CircleAvatar.
        final circleAvatar = find.byType(CircleAvatar);
        if (circleAvatar.evaluate().isNotEmpty) {
          await tester.tap(circleAvatar.first);
        }
      } else {
        await tester.tap(avatarArea.first);
      }
      await tester.pump(TestConfig.pageLoadWait);
      await screenshots.take('account');
      await _goBack(tester);

      // ──────────────────────────────────────────────────────────────
      // 5. Announcements – tap the notification bell
      // ──────────────────────────────────────────────────────────────
      final bellIcon = find.byIcon(Icons.notifications_outlined);
      if (bellIcon.evaluate().isNotEmpty) {
        await tester.tap(bellIcon.first);
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('announcements');
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 6–21. Missions flow
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'View missions')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('missions_all');

        // Subscribed tab
        await _tapTab(tester, 'Subscribed');
        await screenshots.take('missions_subscribed');

        // Go back to All tab for tapping a mission
        await _tapTab(tester, 'All');
        await tester.pump(TestConfig.tabSwitchWait);

        // Tap first mission's "View Details"
        final viewDetailsButtons = find.text('View Details');
        if (viewDetailsButtons.evaluate().isNotEmpty) {
          await tester.tap(viewDetailsButtons.first);
          await tester.pump(TestConfig.pageLoadWait);

          // Mission Details tabs
          await screenshots.take('mission_details_mission_ground');

          await _tapTab(tester, 'Missioners');
          await screenshots.take('mission_details_going');

          await _tapTab(tester, 'Sessions');
          await screenshots.take('mission_details_sessions');

          await _tapTab(tester, 'Souls');
          await screenshots.take('mission_details_souls');

          await _tapTab(tester, 'Debrief Notes');
          await screenshots.take('mission_details_debrief_notes');

          await _tapTab(tester, 'Mission Questions');
          await screenshots.take('mission_details_mission_questions');

          await _tapTab(tester, 'Financials');
          await screenshots.take('mission_details_financials');

          await _tapTab(tester, 'Gallery');
          await screenshots.take('mission_details_gallery');

          // ── Modals on detail tabs ──

          // Add Session modal (Sessions tab)
          await _tapTab(tester, 'Sessions');
          await tester.pump(TestConfig.tabSwitchWait);
          if (await _tapFAB(tester)) {
            await tester.pump(TestConfig.modalWait);
            await screenshots.take('add_session_modal');
            await _dismissModal(tester);
          }

          // Add Soul modal (Souls tab)
          await _tapTab(tester, 'Souls');
          await tester.pump(TestConfig.tabSwitchWait);
          if (await _tapFAB(tester)) {
            await tester.pump(TestConfig.modalWait);
            await screenshots.take('add_soul_modal');
            await _dismissModal(tester);
          }

          // Add Debrief Note modal (Debrief Notes tab)
          await _tapTab(tester, 'Debrief Notes');
          await tester.pump(TestConfig.tabSwitchWait);
          if (await _tapFAB(tester)) {
            await tester.pump(TestConfig.modalWait);
            await screenshots.take('add_debrief_note_modal');
            await _dismissModal(tester);
          }

          // Add Mission Question modal (Mission Questions tab)
          await _tapTab(tester, 'Mission Questions');
          await tester.pump(TestConfig.tabSwitchWait);
          if (await _tapFAB(tester)) {
            await tester.pump(TestConfig.modalWait);
            await screenshots.take('add_mission_question_modal');
            await _dismissModal(tester);
          }

          // ── Session Details ──
          await _tapTab(tester, 'Sessions');
          await tester.pump(TestConfig.tabSwitchWait);
          // Try tapping the first session item in the list.
          final sessionItems = find.byType(ListTile);
          final sessionCards = find.byType(Card);
          final tappable = sessionItems.evaluate().isNotEmpty
              ? sessionItems
              : sessionCards;
          if (tappable.evaluate().isNotEmpty) {
            await tester.tap(tappable.first);
            await tester.pump(TestConfig.pageLoadWait);
            await screenshots.take('session_details');

            await _scrollDown(tester);
            await screenshots.take('session_details_scrolled');
            await _goBack(tester);
          }

          // Back from Mission Details
          await _goBack(tester);
        }

        // Back from Missions
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 22–25. LMS flow
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Learn something')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('lms');

        // Tap first course
        final courseCards = find.byType(GestureDetector);
        if (courseCards.evaluate().length > 1) {
          await tester.tap(courseCards.at(1));
          await tester.pump(TestConfig.pageLoadWait);
          await screenshots.take('course_details');

          // Tap first module
          final moduleItems = find.byType(GestureDetector);
          if (moduleItems.evaluate().length > 1) {
            await tester.tap(moduleItems.at(1));
            await tester.pump(TestConfig.pageLoadWait);
            await screenshots.take('module_details');

            // Tap first lesson
            final lessonItems = find.byType(GestureDetector);
            if (lessonItems.evaluate().length > 1) {
              await tester.tap(lessonItems.at(1));
              await tester.pump(TestConfig.pageLoadWait);
              await screenshots.take('lesson_details');
              await _goBack(tester);
            }
            await _goBack(tester);
          }
          await _goBack(tester);
        }
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 26. Student FAQs
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'View student FAQs')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('student_faqs');
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 27–28. Student Enquiries flow
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Minister to a student')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('student_enquiries');

        // Tap first enquiry (InkWell-based card)
        final enquiryCards = find.byType(InkWell);
        if (enquiryCards.evaluate().isNotEmpty) {
          await tester.tap(enquiryCards.first);
          await tester.pump(TestConfig.pageLoadWait);
          await screenshots.take('enquiry_replies');
          await _goBack(tester);
        }
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 29. Mission Ground Suggestions
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Suggest a mission')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('mission_ground_suggestions');
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 30–34. Events flow
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Register for an event')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('events_all');

        // Subscribed tab
        await _tapTab(tester, 'Subscribed');
        await screenshots.take('events_subscribed');

        // Back to All tab for tapping an event
        await _tapTab(tester, 'All');
        await tester.pump(TestConfig.tabSwitchWait);

        // Tap first event's "View Details"
        final eventViewDetails = find.text('View Details');
        if (eventViewDetails.evaluate().isNotEmpty) {
          await tester.tap(eventViewDetails.first);
          await tester.pump(TestConfig.pageLoadWait);

          // Event Details tabs
          await screenshots.take('event_details_info');

          await _tapTab(tester, 'Gallery');
          await screenshots.take('event_details_gallery');

          // Event subscription modal (Info tab FAB)
          await _tapTab(tester, 'Information');
          await tester.pump(TestConfig.tabSwitchWait);
          if (await _tapFAB(tester)) {
            await tester.pump(TestConfig.modalWait);
            await screenshots.take('event_subscription_modal');
            await _dismissModal(tester);
          }

          await _goBack(tester);
        }
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 35. Prayer Requests
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Share a prayer request')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('prayer_requests');
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 36. Giving
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'Give')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('giving');
        await _goBack(tester);
      }

      // ──────────────────────────────────────────────────────────────
      // 37. Wrapped
      // ──────────────────────────────────────────────────────────────
      if (await _tapActionCard(tester, 'View my impact')) {
        await tester.pump(TestConfig.pageLoadWait);
        await screenshots.take('wrapped');
        await _goBack(tester);
      }
    },
  );
}

// ══════════════════════════════════════════════════════════════════════
// Helpers
// ══════════════════════════════════════════════════════════════════════

/// Whether the current page contains [text] (e.g. a page title).
bool _isOnPage(WidgetTester tester, String text) {
  return find.text(text).evaluate().isNotEmpty;
}

/// Tap an action card on the landing page by its title text.
///
/// Scrolls down first if the card isn't visible yet.
/// Returns `true` if the card was found and tapped.
Future<bool> _tapActionCard(WidgetTester tester, String title) async {
  final cardText = find.text(title);

  // If not visible, scroll down until it appears.
  if (cardText.evaluate().isEmpty) {
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isEmpty) {
      log('No Scrollable found — cannot scroll to "$title"');
      return false;
    }

    // Manual scroll loop to avoid Bad state / timeout issues.
    var attempts = 50;
    while (cardText.evaluate().isEmpty && attempts > 0) {
      await tester.drag(scrollable.first, const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 50));
      attempts--;
    }
    await tester.pump(TestConfig.shortWait);
  }

  if (cardText.evaluate().isEmpty) {
    log('Action card "$title" not found — skipping');
    return false;
  }

  await tester.tap(cardText.first);
  await tester.pump(TestConfig.navigationWait);
  return true;
}

/// Tap a tab by its label text.
///
/// Scrolls off-screen tabs into view before tapping.
Future<void> _tapTab(WidgetTester tester, String label) async {
  final tab = find.descendant(
    of: find.byType(TabBar),
    matching: find.text(label),
  );
  // Fall back to a plain text finder when there is no TabBar ancestor
  // (e.g. segmented controls or custom tab rows).
  final target = tab.evaluate().isNotEmpty ? tab : find.text(label);
  if (target.evaluate().isNotEmpty) {
    await tester.ensureVisible(target.first);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(target.first);
    await tester.pump(TestConfig.tabSwitchWait);
  }
}

/// Tap the FAB if present. Returns true if tapped.
Future<bool> _tapFAB(WidgetTester tester) async {
  final fab = find.byType(FloatingActionButton);
  if (fab.evaluate().isNotEmpty) {
    await tester.tap(fab.first);
    return true;
  }
  return false;
}

/// Dismiss a modal/bottom-sheet (including wolt_modal sheets).
Future<void> _dismissModal(WidgetTester tester) async {
  // Simulate system back to pop the modal route. This is more reliable than
  // tapping the barrier, especially for wolt_modal sheets.
  await (tester.binding as dynamic).handlePopRoute();
  await tester.pump(TestConfig.modalWait);
}

/// Scroll down by a large offset.
Future<void> _scrollDown(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isNotEmpty) {
    await tester.drag(scrollable.first, const Offset(0, -500));
    await tester.pump(TestConfig.shortWait);
  }
}

/// Scroll back to the top.
Future<void> _scrollToTop(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isNotEmpty) {
    await tester.drag(scrollable.first, const Offset(0, 2000));
    await tester.pump(TestConfig.shortWait);
  }
}

/// Press the back button (AppBar leading or Android back).
Future<void> _goBack(WidgetTester tester) async {
  final backButton = find.byType(BackButton);
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton.first);
    await tester.pump(TestConfig.navigationWait);
    return;
  }

  // Fallback: try the leading icon button with arrow_back.
  final arrowBack = find.byIcon(Icons.arrow_back);
  if (arrowBack.evaluate().isNotEmpty) {
    await tester.tap(arrowBack.first);
    await tester.pump(TestConfig.navigationWait);
    return;
  }

  // Fallback: try any IconButton that looks like a back button.
  final arrowBackIos = find.byIcon(Icons.arrow_back_ios);
  if (arrowBackIos.evaluate().isNotEmpty) {
    await tester.tap(arrowBackIos.first);
    await tester.pump(TestConfig.navigationWait);
    return;
  }

  // Last resort: simulate system back via the binding.
  log('Could not find back button — simulating system back');
  await (tester.binding as dynamic).handlePopRoute();
  await tester.pump(TestConfig.navigationWait);
}

/// Silent observer to avoid noisy logs during tests.
class _SilentBlocObserver extends BlocObserver {
  const _SilentBlocObserver();
}
