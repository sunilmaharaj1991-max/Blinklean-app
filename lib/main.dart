import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'amplifyconfiguration.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/admin/admin_provider_onboarding_screen.dart';
import 'screens/provider/provider_login_screen.dart';
import 'screens/provider/partner_navigation_screen.dart';
import 'screens/admin/admin_navigation_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const BlinKleanApp());
}

Future<void> _configureAmplify() async {
  try {
    if (!Amplify.isConfigured) {
      // Add the Auth and Storage plugins
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();

      await Amplify.addPlugins([auth, storage]);

      // Configure with the generated file
      await Amplify.configure(amplifyconfig);
    }
    safePrint('BlinkLean Backend is connected! 🚀');
  } on AmplifyAlreadyConfiguredException {
    safePrint('BlinkLean AWS: Already configured');
  } catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class BlinKleanApp extends StatefulWidget {
  const BlinKleanApp({super.key});

  @override
  State<BlinKleanApp> createState() => _BlinKleanAppState();
}

class _BlinKleanAppState extends State<BlinKleanApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlinKlean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainEntry(),
        '/admin-onboarding': (context) => const AdminProviderOnboardingScreen(),
        '/provider-login': (context) => const ProviderLoginScreen(),
        '/admin-dashboard': (context) => const AdminNavigationScreen(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/partner-home': (context) => const PartnerNavigationScreen(),
        '/customer-home': (context) => const MainNavigationScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
        '/verify-otp': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return OtpVerificationScreen(
            phoneNumber: args['phoneNumber'] as String,
            isSignUp: args['isSignUp'] as bool? ?? false,
          );
        },
      },
    );
  }
}

class MainEntry extends StatefulWidget {
  const MainEntry({super.key});

  @override
  State<MainEntry> createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  final AuthService _auth = AuthService();
  late Future<UserRole> _roleFuture;

  @override
  void initState() {
    super.initState();
    _roleFuture = _auth.getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRole>(
      future: _roleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final role = snapshot.data ?? UserRole.customer;
        
        switch (role) {
          case UserRole.admin:
            return const AdminNavigationScreen();
          case UserRole.partner:
            return const PartnerNavigationScreen();
          case UserRole.customer:
            return const MainNavigationScreen();
        }
      },
    );
  }
}
