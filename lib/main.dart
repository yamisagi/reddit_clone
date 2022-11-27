import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/views/login_view.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Clone',
      theme: ColorPallete.darkModeAppTheme,
      home: const LoginView(),
    );
  }
}
