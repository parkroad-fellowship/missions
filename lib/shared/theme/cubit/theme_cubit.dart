import 'package:app/enums/common/prf_theme_mode.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

/// Cubit for managing the app's theme mode.
///
/// Theme preference is persisted to Hive storage and restored on app start.
///
/// Usage:
/// ```dart
/// // Toggle theme
/// context.read<ThemeCubit>().toggleTheme();
///
/// // Set specific mode
/// context.read<ThemeCubit>().setDarkMode();
/// context.read<ThemeCubit>().setLightMode();
/// context.read<ThemeCubit>().setSystemMode();
/// ```
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required HiveService hiveService})
    : _hiveService = hiveService,
      super(const ThemeState.initial()) {
    _loadSavedTheme();
  }

  final HiveService _hiveService;

  /// Get the current theme mode, defaulting to system if not loaded yet.
  PRFThemeMode get currentThemeMode => state.maybeWhen(
    loaded: (themeMode) => themeMode,
    orElse: () => PRFThemeMode.system,
  );

  /// Whether the current theme is dark mode.
  bool get isDarkMode => currentThemeMode == PRFThemeMode.dark;

  /// Whether the current theme is light mode.
  bool get isLightMode => currentThemeMode == PRFThemeMode.light;

  /// Whether the theme follows system settings.
  bool get isSystemMode => currentThemeMode == PRFThemeMode.system;

  /// Load saved theme preference from Hive.
  void _loadSavedTheme() {
    final savedTheme = _hiveService.settings.getThemeMode();
    emit(ThemeState.loaded(themeMode: savedTheme));
  }

  /// Toggle between light and dark modes.
  ///
  /// If currently in system mode, switches to light mode.
  void toggleTheme() {
    final newMode = switch (currentThemeMode) {
      PRFThemeMode.light => PRFThemeMode.dark,
      PRFThemeMode.dark => PRFThemeMode.light,
      PRFThemeMode.system => PRFThemeMode.light,
    };
    _setAndPersistTheme(newMode);
  }

  /// Set a specific theme mode.
  void setThemeMode(PRFThemeMode mode) {
    _setAndPersistTheme(mode);
  }

  /// Set to light mode.
  void setLightMode() => setThemeMode(PRFThemeMode.light);

  /// Set to dark mode.
  void setDarkMode() => setThemeMode(PRFThemeMode.dark);

  /// Set to follow system settings.
  void setSystemMode() => setThemeMode(PRFThemeMode.system);

  void _setAndPersistTheme(PRFThemeMode mode) {
    _hiveService.settings.setThemeMode(mode);
    emit(ThemeState.loaded(themeMode: mode));
  }
}
