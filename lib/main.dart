import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'amplifyconfiguration.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/admin/admin_provider_onboarding_screen.dart';
import 'screens/provider/provider_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlinKleanApp());
}

class BlinKleanApp extends StatefulWidget {
  const BlinKleanApp({super.key});

  @override
  State<BlinKleanApp> createState() => _BlinKleanAppState();
}

class _BlinKleanAppState extends State<BlinKleanApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      if (!Amplify.isConfigured) {
        // Initialize API and add to plugins
        await Amplify.addPlugins([
          AmplifyAuthCognito(),
          AmplifyAPI(),
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

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
       // Use custom forms for Phone Auth
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.name(required: true),
          SignUpFormField.phoneNumber(required: true),
        ],
      ),
      
      // Use our premium custom LoginScreen
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
          case AuthenticatorStep.signUp:
          case AuthenticatorStep.confirmSignUp:
            return const LoginScreen();
          default:
            return null; // Let default handle others if needed
        }
      },
      
      child: const MainNavigationScreen(),
    );
  }
}
