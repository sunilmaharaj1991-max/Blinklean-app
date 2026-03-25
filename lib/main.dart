import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const BlinKleanApp());
}

class BlinKleanApp extends StatelessWidget {
  const BlinKleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlinKlean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Bypassing login for now based on user request
    return const MainNavigationScreen();
  }
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthWrapper();
  }
}
