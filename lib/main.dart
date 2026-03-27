import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
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
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const BlinKleanApp());
}

Future<void> _configureAmplify() async {
  try {
    if (!Amplify.isConfigured) {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyStorageS3(),
      ]);
      await Amplify.configure(amplifyconfig);
    }
    debugPrint('BlinkLean AWS: Successfully configured');
  } on AmplifyAlreadyConfiguredException {
    debugPrint('BlinkLean AWS: Already configured');
  } catch (e) {
    debugPrint('BlinkLean AWS Error: $e');
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

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.name(required: true),
          SignUpFormField.phoneNumber(required: true),
        ],
      ),
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
          case AuthenticatorStep.signUp:
          case AuthenticatorStep.confirmSignUp:
            return const LoginScreen();
          default:
            return null;
        }
      },
      child: FutureBuilder<UserRole>(
        future: _auth.getUserRole(),
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
      ),
    );
  }
}
