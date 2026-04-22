import 'package:flutter/material.dart';
import 'package:practicas/Widgets/pokemon_widget.dart';


abstract class PokemonThemes {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: _lightColorScheme,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: _darkColorScheme,
      );

  static ThemeData get altTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: _altColorScheme,
      );

  // Grey level
  static Color greyLevelLight = const Color(0xFFF2F2F2);
  static Color greyLevelMedium = const Color(0xFFE2E2E2);

  // Others
  static Color backgroundDetails = const Color(0xFF333333);
  static Color textWhite = const Color(0xFFFFFFFF);
  static Color textBlack = const Color(0xFF17171B);
  static Color textGrey = const Color(0xFF747476);
  static Color textNumber = const Color(0xFF17171B).withOpacity(0.6);
  static Color heart = const Color(0xFF950C03FF);
}

const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFEA5D60),
  onPrimary: Color.fromARGB(255, 43, 169, 50),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF21005D),
  secondary: Color(0xFF625B71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE8DEF8),
  onSecondaryContainer: Color(0xFF1D192B),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD8E4),
  onTertiaryContainer: Color(0xFF31111D),
  error: Color(0xFFF63F34),
  onError: Color(0xFF950C03),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  outline: Color(0xFF79747E),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceContainerHighest: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFD0BCFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF6750A4),
  outlineVariant: Color(0xFFCAC4D0),
  scrim: Color(0xFF000000),
);

const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFEA5D60),
  onPrimary: Color(0xFF1C1C1C),
  primaryContainer: Color(0xFF3A3A3A),
  onPrimaryContainer: Color(0xFFF4F4F4),
  secondary: Color(0xFF8E8E8E),
  onSecondary: Color(0xFF121212),
  secondaryContainer: Color(0xFF2C2C2C),
  onSecondaryContainer: Color(0xFFE0E0E0),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF4A3A41),
  onTertiaryContainer: Color(0xFFFFD8E4),
  error: Color(0xFFF63F34),
  onError: Color(0xFF950C03),
  errorContainer: Color(0xFF5B1A17),
  onErrorContainer: Color(0xFFF9DEDC),
  outline: Color(0xFF9E9E9E),
  surface: Color(0xFF121212),
  onSurface: Color(0xFFE0E0E0),
  surfaceContainerHighest: Color(0xFF1F1F1F),
  onSurfaceVariant: Color(0xFFB0B0B0),
  inverseSurface: Color(0xFFEAEAEA),
  onInverseSurface: Color(0xFF222222),
  inversePrimary: Color(0xFFD0BCFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFEA5D60),
  outlineVariant: Color(0xFF616161),
  scrim: Color(0xFF000000),
);

const _altColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2E7D32), // Verde como tema alterno
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC8E6C9),
  onPrimaryContainer: Color(0xFF0F3D16),
  secondary: Color(0xFF00695C),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFB2DFDB),
  onSecondaryContainer: Color(0xFF00302B),
  tertiary: Color(0xFF558B2F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFDCEDC8),
  onTertiaryContainer: Color(0xFF1C3B0D),
  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFCDD2),
  onErrorContainer: Color(0xFF4A1212),
  outline: Color(0xFF79747E),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceContainerHighest: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFB5D6B7),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF2E7D32),
  outlineVariant: Color(0xFFCAC4D0),
  scrim: Color(0xFF000000),
);

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'normal':
      return Colors.brown.shade300;
    case 'fighting':
      return Colors.red.shade700;
    case 'flying':
      return Colors.blueGrey.shade200;
    case 'poison':
      return Colors.purple.shade400;
    case 'ground':
      return Colors.brown.shade400;
    case 'rock':
      return Colors.grey.shade600;
    case 'bug':
      return Colors.lightGreen.shade600;
    case 'ghost':
      return Colors.indigo.shade400;
    case 'steel':
      return Colors.blueGrey.shade400;
    case 'fire':
      return Colors.red.shade400;
    case 'water':
      return Colors.blue.shade400;
    case 'grass':
      return Colors.green.shade400;
    case 'electric':
      return Colors.yellow.shade600;
    case 'psychic':
      return Colors.pink.shade400;
    case 'ice':
      return Colors.cyan.shade300;
    case 'dragon':
      return Colors.indigo.shade700;
    case 'dark':
      return Colors.grey.shade800;
    case 'fairy':
      return Colors.pink.shade300;
    case 'stellar':
      return Colors.tealAccent.shade400;
    default:
      return Colors.grey.shade400;
  }
}


IconData getTypeIcon(String type) {
  switch (type.toLowerCase()) {
    case 'normal':
      return Icons.circle_outlined;
    case 'fighting':
      return Icons.sports_martial_arts_rounded;
    case 'flying':
      return Icons.air_rounded;
    case 'poison':
      return Icons.coronavirus_rounded;
    case 'ground':
      return Icons.terrain_rounded;
    case 'rock':
      return Icons.landscape_rounded;
    case 'bug':
      return Icons.bug_report_rounded;
    case 'ghost':
      return Icons.nightlight_rounded;
    case 'steel':
      return Icons.hardware_rounded;
    case 'fire':
      return Icons.local_fire_department_rounded;
    case 'water':
      return Icons.water_drop_rounded;
    case 'grass':
      return Icons.eco_rounded;
    case 'electric':
      return Icons.bolt_rounded;
    case 'psychic':
      return Icons.psychology_rounded;
    case 'ice':
      return Icons.ac_unit_rounded;
    case 'dragon':
      return Icons.whatshot_rounded;
    case 'dark':
      return Icons.dark_mode_rounded;
    case 'fairy':
      return Icons.auto_awesome_rounded;
    case 'stellar':
      return Icons.star_rate_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}