import 'package:flutter/material.dart';
import 'package:time_tracker/theme/color_schemes.dart';

/// Global Material theme for the app
class TimeTrackerTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      );
}
