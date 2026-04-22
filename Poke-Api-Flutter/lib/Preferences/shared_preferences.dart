import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _keyFavorites = 'favorite_pokemons';


  static Future<void> toggleFavorite(String pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_keyFavorites) ?? [];

    if (favorites.contains(pokemonId)) {
      favorites.remove(pokemonId);
    } else {
      favorites.add(pokemonId);
    }

    await prefs.setStringList(_keyFavorites, favorites);
  }


  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }


  static Future<bool> isFavorite(String pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    return favorites.contains(pokemonId);
  }


  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFavorites);
  }
}

enum AppTheme { light, dark, alternate }

class ThemePreferences {
  static const String _keyTheme = 'app_theme';

  static Future<AppTheme> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_keyTheme);
    switch (index) {
      case 1:
        return AppTheme.dark;
      case 2:
        return AppTheme.alternate;
      case 0:
        return AppTheme.light;
      default:
        return AppTheme.light;
    }
  }

  static Future<void> setTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    final index = switch (theme) { AppTheme.light => 0, AppTheme.dark => 1, AppTheme.alternate => 2 };
    await prefs.setInt(_keyTheme, index);
  }
}
