import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:practicas/Design/themes.dart';
import 'package:practicas/Preferences/shared_preferences.dart';

class ThemeController extends AsyncNotifier<AppTheme> {
  @override
  Future<AppTheme> build() async {
    // Load saved theme from SharedPreferences
    return await ThemePreferences.getTheme();
  }

  Future<void> setTheme(AppTheme theme) async {
    state = AsyncData(theme);
    await ThemePreferences.setTheme(theme);
  }
}

final themeControllerProvider = AsyncNotifierProvider<ThemeController, AppTheme>(() {
  return ThemeController();
});

ThemeData themeDataFor(AppTheme theme) {
  switch (theme) {
    case AppTheme.dark:
      return PokemonThemes.darkTheme;
    case AppTheme.alternate:
      return PokemonThemes.altTheme;
    case AppTheme.light:
    default:
      return PokemonThemes.lightTheme;
  }
}
