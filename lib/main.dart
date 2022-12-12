import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/app_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // For web ensureFlutterViewEmbedderInitialized() ensure that the plugin services are initialized before using them

  WidgetsFlutterBinding.ensureInitialized();
  //Push landscape mode to vertical mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: AppRoot(),
    ),
  );
}
