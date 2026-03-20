import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase_config.dart';
import 'core/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/location_availability_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';
import 'core/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    // Supabase auth state changes
    final session = Supabase.instance.client.auth.currentSession;
    
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && session == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final currentSession = snapshot.data?.session ?? session;
        
        if (currentSession != null) {
          return ListenableBuilder(
            listenable: AppState(),
            builder: (context, child) {
              if (AppState().currentPincode == null) {
                return const LocationAvailabilityScreen();
              }
              return const MainNavigationScreen();
            },
          );
        }
        
        return const LoginScreen();
      },
    );
  }
}
