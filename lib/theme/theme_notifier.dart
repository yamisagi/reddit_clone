import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;  

  ThemeNotifier({
    ThemeMode themeMode = ThemeMode.dark,
  })  : _themeMode = themeMode,
        super(ColorPallete.darkModeAppTheme) {
    getTheme();
  }

  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

    if (isDarkMode) {
      _themeMode = ThemeMode.dark;
      state = ColorPallete.darkModeAppTheme;
    } else {
      _themeMode = ThemeMode.light;
      state = ColorPallete.lightModeAppTheme;
    }
  }

  Future<void> setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      state = ColorPallete.lightModeAppTheme;
      prefs.setBool('isDarkMode', false);
    } else {
      _themeMode = ThemeMode.dark;
      state = ColorPallete.darkModeAppTheme;
      prefs.setBool('isDarkMode', true);
    }

  }
}
