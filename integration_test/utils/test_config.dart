/// Timeout and delay constants for integration tests.
class TestConfig {
  /// Time to wait for a page to load and render data from the API.
  static const pageLoadWait = Duration(seconds: 8);

  /// Shorter wait for pages that load quickly (e.g. static content, tabs).
  static const shortWait = Duration(seconds: 3);

  /// Time to wait after tapping a tab for the content to appear.
  static const tabSwitchWait = Duration(seconds: 3);

  /// Time to wait for modal/bottom-sheet animation to complete.
  static const modalWait = Duration(seconds: 2);

  /// Time to wait for navigation transitions to finish.
  static const navigationWait = Duration(seconds: 2);

  /// Time to wait for sign-in to complete and redirect.
  static const signInWait = Duration(seconds: 10);
}
