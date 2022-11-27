import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/views/login_view.dart';
import 'package:reddit_clone/theme/product_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reddit Clone',
        theme: ColorPallete.darkModeAppTheme,
        home: const LoginView());
  }
}
