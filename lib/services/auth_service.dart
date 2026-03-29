import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'api_service.dart';

enum UserRole { customer, partner, admin }

class AuthService {
  static UserRole? _debugRole;

  Future<UserRole> getUserRole() async {
    if (kDebugMode && _debugRole != null) return _debugRole!;
    
    try {
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final groups = session.userPoolTokensResult.value.idToken.groups;
      
      if (groups.contains('Admins')) return UserRole.admin;
      if (groups.contains('Providers')) return UserRole.partner;
      
      return UserRole.customer; // Default
    } catch (e) {
      debugPrint('Error fetching role: $e');
      return UserRole.customer;
    }
  }

  static void setDebugRole(UserRole role) {
    _debugRole = role;
  }

  static bool get debugRoleSet => _debugRole != null;

  Future<AuthUser?> get currentUser async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  /// Standard Sign-In (Email/Password for Providers)
  Future<SignInResult?> signInProvider(String email, String password) async {
    return await Amplify.Auth.signIn(username: email, password: password);
  }

  /// Phone Sign-In (Trigger SMS OTP for Customers)
  Future<SignInResult?> signInCustomer(String phoneNumber, String password) async {
    return await Amplify.Auth.signIn(username: phoneNumber, password: password);
  }

  Future<SignUpResult> registerWithPhone({
    required String phoneNumber,
    required String password,
    required String name,
    required String email,
    String? address,
  }) async {
    final userAttributes = {
      AuthUserAttributeKey.phoneNumber: phoneNumber,
      AuthUserAttributeKey.name: name,
      AuthUserAttributeKey.email: email,
    };

    return await Amplify.Auth.signUp(
      username: phoneNumber,
      password: password,
      options: SignUpOptions(userAttributes: userAttributes),
    );
  }


  // Google Sign-In is handled via Authenticator or separate UI if configured
  Future<SignInResult?> signInWithGoogle() async {
    return await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<void> hideResetPassword(String phoneNumber) async {
    await Amplify.Auth.resetPassword(username: phoneNumber);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await apiService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  // Resend confirmation code for phone number
  Future<ResendSignUpCodeResult> resendOTP(String phoneNumber) async {
    return await Amplify.Auth.resendSignUpCode(username: phoneNumber);
  }

  // Confirm Signup using OTP for Phone Number
  Future<SignUpResult> confirmRegistrationOTP(
    String phoneNumber,
    String otp,
  ) async {
    return await Amplify.Auth.confirmSignUp(
      username: phoneNumber,
      confirmationCode: otp,
    );
  }

  // Pure OTP login without password requires Custom Auth Trigger in Cognito.
  // For standard flows, we use signIn(phone, password).
  Future<SignInResult> signInWithPhoneOTP(
    String phoneNumber,
    String password,
  ) async {
    return await Amplify.Auth.signIn(
      username: phoneNumber,
      password: password,
    );
  }
}
